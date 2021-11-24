import admin from "firebase-admin";

let firebaseApp;

// Get service account JSON file from Firebase
// Docs: https://firebase.google.com/support/guides/service-accounts 
const serviceAccount = "";

/**
 * Inicialización de Firebase.
 * Para notificaciones
 */
export const initFirebaseAdmin = () => {
  firebaseApp = admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
  });
};

export { firebaseApp };
