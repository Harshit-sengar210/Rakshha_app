"use client";

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { motion } from 'framer-motion';
import { Shield } from 'lucide-react';
import { signInWithEmailAndPassword } from 'firebase/auth';
import { auth, db } from '@/lib/firebase';
import { doc, getDoc } from 'firebase/firestore';

export default function LoginPage() {
  const router = useRouter();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError('');
    
    try {
      const userCredential = await signInWithEmailAndPassword(auth, email, password);
      const uid = userCredential.user.uid;
      
      // Strict authorization check
      const knownAdminUid = "5mKPPive8qTS7ZdqOLQBjk596N03";
      let isAuthorized = false;

      if (uid === knownAdminUid) {
        isAuthorized = true;
      } else {
        // Fallback: check if they exist in the 'admins' Firestore collection
        const adminDoc = await getDoc(doc(db, "admins", uid));
        if (adminDoc.exists()) {
          isAuthorized = true;
        }
      }

      if (!isAuthorized) {
        // If not authorized, sign them out immediately
        await auth.signOut();
        throw new Error("You do not have administrative privileges.");
      }
      
      router.push('/admin');
    } catch (err: any) {
      console.error("Login failed:", err);
      setError("Invalid credentials or you do not have permission.");
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-rakshaa-bg flex flex-col justify-center items-center relative overflow-hidden">
      {/* Background Shapes */}
      <motion.div 
        initial={{ opacity: 0, scale: 0.8 }}
        animate={{ opacity: 1, scale: 1 }}
        transition={{ duration: 1.5, ease: "easeOut" }}
        className="absolute top-[-10%] left-[-10%] w-[500px] h-[500px] bg-rakshaa-blush rounded-full mix-blend-multiply filter blur-3xl opacity-70"
      />
      <motion.div 
        initial={{ opacity: 0, scale: 0.8 }}
        animate={{ opacity: 1, scale: 1 }}
        transition={{ duration: 1.5, delay: 0.2, ease: "easeOut" }}
        className="absolute bottom-[-10%] right-[-10%] w-[600px] h-[600px] bg-rakshaa-green rounded-full mix-blend-multiply filter blur-3xl opacity-50"
      />

      <motion.div 
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6 }}
        className="z-10 w-full max-w-md bg-white rounded-2xl shadow-xl border border-rakshaa-border p-8"
      >
        <div className="flex flex-col items-center mb-8">
          <motion.div 
            initial={{ scale: 0 }}
            animate={{ scale: 1 }}
            transition={{ delay: 0.2, type: "spring", stiffness: 200, damping: 20 }}
            className="w-16 h-16 bg-rakshaa-blush rounded-2xl flex items-center justify-center mb-4 text-rakshaa-coral"
          >
            <Shield size={32} />
          </motion.div>
          <h1 className="text-2xl font-bold text-rakshaa-navy">Rakshaa</h1>
          <p className="text-rakshaa-muted font-medium mt-1">Safety Operations</p>
        </div>

        <form onSubmit={handleLogin} className="space-y-5">
          {error && (
            <div className="bg-rakshaa-danger/10 border border-rakshaa-danger/20 text-rakshaa-danger text-sm font-semibold p-3 rounded-lg flex items-center justify-center">
              {error}
            </div>
          )}
          
          <div>
            <label className="block text-sm font-semibold text-rakshaa-navy mb-1.5">Email</label>
            <input 
              type="email" 
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
              className="w-full px-4 py-2.5 rounded-lg border border-rakshaa-border bg-rakshaa-white focus:outline-none focus:ring-2 focus:ring-rakshaa-coral/50 focus:border-rakshaa-coral transition-colors"
              placeholder="operator@rakshaa.com"
            />
          </div>
          <div>
            <label className="block text-sm font-semibold text-rakshaa-navy mb-1.5">Password</label>
            <input 
              type="password" 
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
              className="w-full px-4 py-2.5 rounded-lg border border-rakshaa-border bg-rakshaa-white focus:outline-none focus:ring-2 focus:ring-rakshaa-coral/50 focus:border-rakshaa-coral transition-colors"
              placeholder="••••••••"
            />
          </div>
          
          <div className="flex items-center justify-between">
            <label className="flex items-center space-x-2 cursor-pointer">
              <input type="checkbox" className="w-4 h-4 rounded border-rakshaa-border text-rakshaa-coral focus:ring-rakshaa-coral" />
              <span className="text-sm text-rakshaa-muted">Remember this device</span>
            </label>
          </div>

          <button 
            type="submit"
            disabled={loading}
            className="w-full bg-rakshaa-navy hover:bg-rakshaa-navy/90 text-white font-semibold py-3 rounded-lg transition-colors flex justify-center items-center h-12"
          >
            {loading ? (
              <motion.div 
                animate={{ rotate: 360 }}
                transition={{ repeat: Infinity, duration: 1, ease: "linear" }}
                className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full"
              />
            ) : (
              "Sign In"
            )}
          </button>
        </form>

        <div className="mt-8 text-center text-xs text-rakshaa-muted flex flex-col gap-1">
          <p>Two-factor authentication ready</p>
          <p>Authorized access only</p>
        </div>
      </motion.div>
    </div>
  );
}
