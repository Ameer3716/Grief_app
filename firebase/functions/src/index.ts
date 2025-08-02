import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

// Initialize Firestore
const db = admin.firestore();

// Companion matching function
export const suggestCompanions = functions.firestore
  .document('companions/{userId}')
  .onWrite(async (change, context) => {
    const userId = context.params.userId;
    
    if (!change.after.exists) {
      return null; // Document was deleted
    }
    
    const userData = change.after.data();
    if (!userData) return null;
    
    try {
      // Find compatible companions based on grief type and stage
      const compatibleCompanions = await db.collection('companions')
        .where('griefType', '==', userData.griefType)
        .where('allowMatching', '==', true)
        .limit(10)
        .get();
      
      const suggestions: any[] = [];
      
      compatibleCompanions.forEach(doc => {
        if (doc.id !== userId) {
          const companionData = doc.data();
          let compatibilityScore = 0;
          
          // Same grief type = +3 points
          if (companionData.griefType === userData.griefType) {
            compatibilityScore += 3;
          }
          
          // Similar grief stage = +2 points
          if (companionData.griefStage === userData.griefStage) {
            compatibilityScore += 2;
          }
          
          // Different but complementary stages = +1 point
          const complementaryStages = {
            'Early Grief': ['Working Through It', 'Acceptance'],
            'Working Through It': ['Acceptance', 'Reconstruction'],
            'Acceptance': ['Reconstruction', 'Working Through It'],
            'Reconstruction': ['Acceptance']
          };
          
          if (complementaryStages[userData.griefStage]?.includes(companionData.griefStage)) {
            compatibilityScore += 1;
          }
          
          if (compatibilityScore > 0) {
            suggestions.push({
              userId: doc.id,
              name: companionData.name,
              griefStage: companionData.griefStage,
              griefType: companionData.griefType,
              bio: companionData.bio,
              compatibilityScore,
              profileImageUrl: companionData.profileImageUrl || null
            });
          }
        }
      });
      
      // Sort by compatibility score
      suggestions.sort((a, b) => b.compatibilityScore - a.compatibilityScore);
      
      // Store suggestions in user's document
      await db.collection('users').doc(userId).collection('suggestions').doc('companions').set({
        suggestions: suggestions.slice(0, 5), // Top 5 suggestions
        lastUpdated: admin.firestore.FieldValue.serverTimestamp()
      });
      
      console.log(`Generated ${suggestions.length} companion suggestions for user ${userId}`);
      
    } catch (error) {
      console.error('Error generating companion suggestions:', error);
    }
    
    return null;
  });

// Prayer count aggregation
export const incrementPrayerCount = functions.firestore
  .document('prayerRequests/{requestId}/prayers/{userId}')
  .onCreate(async (snap, context) => {
    const requestId = context.params.requestId;
    
    try {
      // Increment the prayer count in the parent document
      await db.collection('prayerRequests').doc(requestId).update({
        prayCount: admin.firestore.FieldValue.increment(1),
        lastPrayedAt: admin.firestore.FieldValue.serverTimestamp()
      });
      
      console.log(`Incremented prayer count for request ${requestId}`);
      
    } catch (error) {
      console.error('Error incrementing prayer count:', error);
    }
    
    return null;
  });

// Connection request notifications
export const notifyConnectionRequest = functions.firestore
  .document('connectionRequests/{requestId}')
  .onCreate(async (snap, context) => {
    const requestData = snap.data();
    
    try {
      // Get the target user's FCM token
      const targetUserDoc = await db.collection('users').doc(requestData.toUserId).get();
      const targetUser = targetUserDoc.data();
      
      if (targetUser?.fcmToken) {
        // Get the sender's name
        const senderDoc = await db.collection('users').doc(requestData.fromUserId).get();
        const senderName = senderDoc.data()?.name || 'Someone';
        
        const message = {
          token: targetUser.fcmToken,
          notification: {
            title: 'New Companion Request',
            body: `${senderName} wants to connect with you as a grief companion`
          },
          data: {
            type: 'connection_request',
            requestId: context.params.requestId,
            fromUserId: requestData.fromUserId
          }
        };
        
        await admin.messaging().send(message);
        console.log(`Sent connection request notification to ${requestData.toUserId}`);
      }
      
    } catch (error) {
      console.error('Error sending connection request notification:', error);
    }
    
    return null;
  });

// Handle connection request acceptance
export const handleConnectionAcceptance = functions.firestore
  .document('connectionRequests/{requestId}')
  .onUpdate(async (change, context) => {
    const beforeData = change.before.data();
    const afterData = change.after.data();
    
    // Check if status changed to 'accepted'
    if (beforeData.status !== 'accepted' && afterData.status === 'accepted') {
      try {
        // Create a connection document
        const connectionData = {
          user1Id: afterData.fromUserId,
          user2Id: afterData.toUserId,
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
          status: 'active'
        };
        
        const connectionRef = await db.collection('connections').add(connectionData);
        
        // Create a chat room for the connected companions
        const chatData = {
          participants: [afterData.fromUserId, afterData.toUserId],
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
          lastMessage: null,
          lastMessageAt: null
        };
        
        await db.collection('chats').doc(connectionRef.id).set(chatData);
        
        // Notify the requester that their request was accepted
        const requesterDoc = await db.collection('users').doc(afterData.fromUserId).get();
        const requester = requesterDoc.data();
        
        if (requester?.fcmToken) {
          const accepterDoc = await db.collection('users').doc(afterData.toUserId).get();
          const accepterName = accepterDoc.data()?.name || 'Someone';
          
          const message = {
            token: requester.fcmToken,
            notification: {
              title: 'Connection Accepted!',
              body: `${accepterName} accepted your companion request`
            },
            data: {
              type: 'connection_accepted',
              connectionId: connectionRef.id,
              companionId: afterData.toUserId
            }
          };
          
          await admin.messaging().send(message);
        }
        
        console.log(`Created connection ${connectionRef.id} between ${afterData.fromUserId} and ${afterData.toUserId}`);
        
      } catch (error) {
        console.error('Error handling connection acceptance:', error);
      }
    }
    
    return null;
  });

// Daily devotion scheduler
export const scheduleDailyDevotions = functions.pubsub
  .schedule('0 8 * * *') // Every day at 8 AM
  .timeZone('America/New_York')
  .onRun(async (context) => {
    try {
      // Get today's devotion
      const today = new Date();
      const todayString = today.toISOString().split('T')[0];
      
      const devotionQuery = await db.collection('dailyDevotions')
        .where('date', '==', todayString)
        .limit(1)
        .get();
      
      if (devotionQuery.empty) {
        console.log('No devotion found for today');
        return null;
      }
      
      const devotion = devotionQuery.docs[0].data();
      
      // Get all users who have daily devotion notifications enabled
      const usersQuery = await db.collection('users')
        .where('preferences.dailyDevotion', '==', true)
        .get();
      
      const tokens: string[] = [];
      
      usersQuery.forEach(doc => {
        const userData = doc.data();
        if (userData.fcmToken) {
          tokens.push(userData.fcmToken);
        }
      });
      
      if (tokens.length > 0) {
        const message = {
          tokens: tokens,
          notification: {
            title: 'Daily Devotion',
            body: devotion.title
          },
          data: {
            type: 'daily_devotion',
            devotionId: devotionQuery.docs[0].id
          }
        };
        
        const response = await admin.messaging().sendMulticast(message);
        console.log(`Sent daily devotion notifications to ${response.successCount} users`);
      }
      
    } catch (error) {
      console.error('Error sending daily devotion notifications:', error);
    }
    
    return null;
  });

// Clean up old prayer requests (optional)
export const cleanupOldPrayerRequests = functions.pubsub
  .schedule('0 2 * * 0') // Every Sunday at 2 AM
  .timeZone('America/New_York')
  .onRun(async (context) => {
    try {
      const thirtyDaysAgo = new Date();
      thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);
      
      const oldRequestsQuery = await db.collection('prayerRequests')
        .where('createdAt', '<', thirtyDaysAgo)
        .get();
      
      const batch = db.batch();
      let deleteCount = 0;
      
      oldRequestsQuery.forEach(doc => {
        batch.delete(doc.ref);
        deleteCount++;
      });
      
      if (deleteCount > 0) {
        await batch.commit();
        console.log(`Deleted ${deleteCount} old prayer requests`);
      }
      
    } catch (error) {
      console.error('Error cleaning up old prayer requests:', error);
    }
    
    return null;
  });

// User activity tracking
export const trackUserActivity = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }
  
  const userId = context.auth.uid;
  const { action, metadata } = data;
  
  try {
    await db.collection('userActivity').doc(userId).collection('activities').add({
      action,
      metadata: metadata || {},
      timestamp: admin.firestore.FieldValue.serverTimestamp()
    });
    
    // Update user's last active timestamp
    await db.collection('users').doc(userId).update({
      lastActive: admin.firestore.FieldValue.serverTimestamp()
    });
    
    return { success: true };
    
  } catch (error) {
    console.error('Error tracking user activity:', error);
    throw new functions.https.HttpsError('internal', 'Failed to track activity');
  }
});