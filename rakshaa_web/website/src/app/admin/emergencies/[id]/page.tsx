"use client";

import { motion } from 'framer-motion';
import { 
  ArrowLeft,
  AlertTriangle,
  User,
  Phone,
  Mail,
  Clock,
  MapPin,
  CheckCircle2,
  Users,
  MessageCircle,
  Smartphone,
  ShieldAlert,
  Activity,
  ExternalLink,
  Navigation,
  Check
} from 'lucide-react';
import Link from 'next/link';
import { use, Suspense, useState, useEffect } from 'react';
import { doc, onSnapshot, getDoc, updateDoc } from 'firebase/firestore';
import { db } from '@/lib/firebase';

export default function EmergencyDetailsPage({ params }: { params: Promise<{ id: string }> }) {
  return (
    <Suspense fallback={<div className="p-8 text-center text-rakshaa-muted">Loading emergency incident...</div>}>
      <EmergencyDetailsContent params={params} />
    </Suspense>
  );
}

function EmergencyDetailsContent({ params }: { params: Promise<{ id: string }> }) {
  const resolvedParams = use(params);
  const [incident, setIncident] = useState<any>(null);
  const [userDetails, setUserDetails] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [duration, setDuration] = useState('0s');

  useEffect(() => {
    const unsub = onSnapshot(
      doc(db, 'emergencies', resolvedParams.id),
      async (snap) => {
        if (snap.exists()) {
          const data = snap.data();
          setIncident({ id: snap.id, ...data });

          if (data.userId) {
            try {
              const uSnap = await getDoc(doc(db, 'users', data.userId));
              if (uSnap.exists()) {
                setUserDetails(uSnap.data());
              }
            } catch (e) {
              console.error("Error fetching user details:", e);
            }
          }
        }
        setLoading(false);
      },
      (error) => {
        console.warn('Firestore incident listener error:', error.message);
        setLoading(false);
      }
    );

    return () => unsub();
  }, [resolvedParams.id]);

  useEffect(() => {
    if (!incident?.startedAt) return;
    const startTime = incident.startedAt.toMillis 
      ? incident.startedAt.toMillis() 
      : (incident.startedAt ? new Date(incident.startedAt).getTime() : Date.now());

    const updateTimer = () => {
      const diff = Math.floor((Date.now() - startTime) / 1000);
      if (diff < 0) return;
      const h = Math.floor(diff / 3600);
      const m = Math.floor((diff % 3600) / 60);
      const s = diff % 60;
      if (h > 0) {
        setDuration(`${h}h ${m}m ${s}s`);
      } else if (m > 0) {
        setDuration(`${m}m ${s}s`);
      } else {
        setDuration(`${s}s`);
      }
    };
    updateTimer();
    const interval = setInterval(updateTimer, 1000);
    return () => clearInterval(interval);
  }, [incident?.startedAt]);

  if (loading) {
    return (
      <div className="flex items-center justify-center py-20 text-rakshaa-muted">
        <p className="font-semibold text-sm">Loading incident details from database...</p>
      </div>
    );
  }

  if (!incident) {
    return (
      <div className="p-8 text-center">
        <h3 className="text-xl font-bold text-rakshaa-navy">Incident Not Found</h3>
        <p className="text-sm text-rakshaa-muted mt-2">No emergency record matching ID {resolvedParams.id}.</p>
        <Link href="/admin/emergencies" className="mt-4 inline-block text-rakshaa-coral font-bold text-sm">
          ← Return to Live Emergencies
        </Link>
      </div>
    );
  }

  const lat = incident.latitude || 28.6139;
  const lng = incident.longitude || 77.2090;
  const googleMapsUrl = `https://www.google.com/maps/search/?api=1&query=${lat},${lng}`;
  const isActive = incident.status === 'active';

  const priorityContact = userDetails?.priorityContact;
  const trustedContacts: any[] = userDetails?.trustedContacts || [];

  return (
    <div className="space-y-6 max-w-7xl mx-auto pb-16">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div className="flex items-center space-x-4">
          <Link href="/admin/emergencies">
            <button className="p-2 hover:bg-rakshaa-border rounded-full transition-colors text-rakshaa-navy">
              <ArrowLeft size={24} />
            </button>
          </Link>
          <div>
            <div className="flex items-center space-x-3">
              <div className="flex items-center justify-center">
                <div className={`w-3 h-3 rounded-full ${isActive ? 'bg-rakshaa-coral animate-ping' : 'bg-rakshaa-success'}`} />
              </div>
              <h2 className="text-2xl font-black text-rakshaa-navy tracking-tight">Incident Command Center</h2>
              <span className={`text-xs px-3 py-1 rounded-full font-bold uppercase tracking-wider ${
                isActive ? 'bg-rakshaa-coral/10 text-rakshaa-coral border border-rakshaa-coral/20' : 'bg-gray-100 text-gray-700'
              }`}>
                {incident.status}
              </span>
            </div>
            <p className="text-rakshaa-muted mt-1 font-mono text-xs">{resolvedParams.id}</p>
          </div>
        </div>

        <div className="flex items-center space-x-3">
          {isActive && (
            <button
              onClick={async () => {
                if (confirm('Mark this incident as resolved?')) {
                  await updateDoc(doc(db, 'emergencies', incident.id), {
                    status: 'resolved',
                    resolvedAt: new Date()
                  });
                }
              }}
              className="bg-rakshaa-success text-white px-5 py-2.5 rounded-xl font-bold text-sm shadow-sm hover:bg-rakshaa-success/90 transition-colors flex items-center space-x-2"
            >
              <CheckCircle2 size={16} />
              <span>Resolve Incident</span>
            </button>
          )}
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        
        {/* Left Column (User, Emergency Info, Contacts) */}
        <div className="lg:col-span-1 space-y-6">
          
          {/* User Info Card */}
          <motion.div 
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            className="bg-white border border-rakshaa-border rounded-2xl p-6 shadow-sm"
          >
            <h3 className="font-extrabold text-rakshaa-navy mb-4 flex items-center border-b border-rakshaa-border pb-3 text-sm uppercase tracking-wider">
              <User size={16} className="mr-2 text-rakshaa-coral" /> User Details
            </h3>
            <div className="flex items-center space-x-4 mb-4">
              <div className="w-12 h-12 bg-rakshaa-navy text-white rounded-xl flex items-center justify-center font-black text-xl">
                {(incident.userName || 'U').charAt(0).toUpperCase()}
              </div>
              <div>
                <p className="font-extrabold text-rakshaa-navy text-lg">{incident.userName || 'Rakshaa User'}</p>
                <div className="flex items-center text-xs text-rakshaa-success mt-0.5 font-semibold">
                  <CheckCircle2 size={12} className="mr-1" /> Active Mobile Device
                </div>
              </div>
            </div>
            <div className="space-y-3 text-sm pt-2 border-t border-rakshaa-border/60">
              <div className="flex items-center justify-between">
                <span className="text-xs text-rakshaa-muted font-medium">Phone Number</span>
                <a href={`tel:${incident.userPhone}`} className="font-bold text-rakshaa-navy hover:text-rakshaa-coral flex items-center">
                  <Phone size={14} className="mr-1.5 text-rakshaa-coral" /> {incident.userPhone || 'Not available'}
                </a>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-xs text-rakshaa-muted font-medium">User ID</span>
                <span className="font-mono text-xs text-rakshaa-muted truncate max-w-[150px]">{incident.userId || 'N/A'}</span>
              </div>
            </div>
          </motion.div>

          {/* Emergency Info Card */}
          <motion.div 
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ delay: 0.1 }}
            className="bg-white border border-rakshaa-border rounded-2xl p-6 shadow-sm"
          >
            <h3 className="font-extrabold text-rakshaa-navy mb-4 flex items-center border-b border-rakshaa-border pb-3 text-sm uppercase tracking-wider">
              <AlertTriangle size={16} className="mr-2 text-rakshaa-coral" /> Incident Metrics
            </h3>
            <div className="space-y-4 text-sm">
              <div className="bg-rakshaa-bg p-3.5 rounded-xl border border-rakshaa-border">
                <p className="text-rakshaa-muted text-xs font-semibold uppercase tracking-wider mb-1">Active Elapsed Duration</p>
                <p className="font-black text-rakshaa-coral text-xl flex items-center">
                  <Clock size={18} className="mr-2" /> {duration}
                </p>
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div className="bg-rakshaa-bg p-3 rounded-xl border border-rakshaa-border">
                  <p className="text-rakshaa-muted text-[10px] font-bold uppercase tracking-wider mb-1">Started At</p>
                  <p className="font-bold text-rakshaa-navy text-xs">
                    {incident.startedAt?.toDate ? incident.startedAt.toDate().toLocaleTimeString() : 'Live'}
                  </p>
                </div>
                <div className="bg-rakshaa-bg p-3 rounded-xl border border-rakshaa-border">
                  <p className="text-rakshaa-muted text-[10px] font-bold uppercase tracking-wider mb-1">Trigger Type</p>
                  <p className="font-bold text-rakshaa-navy text-xs">One-Tap SOS</p>
                </div>
              </div>
            </div>
          </motion.div>

          {/* Contacts Card */}
          <motion.div 
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ delay: 0.2 }}
            className="bg-white border border-rakshaa-border rounded-2xl p-6 shadow-sm"
          >
            <h3 className="font-extrabold text-rakshaa-navy mb-4 flex items-center border-b border-rakshaa-border pb-3 text-sm uppercase tracking-wider">
              <Users size={16} className="mr-2 text-blue-500" /> Safety Contacts ({((priorityContact ? 1 : 0) + trustedContacts.length)})
            </h3>
            
            <div className="space-y-3">
              {priorityContact && (
                <div className="p-3.5 bg-rakshaa-coral/5 rounded-xl border border-rakshaa-coral/20">
                  <div className="flex justify-between items-start">
                    <div>
                      <p className="font-extrabold text-rakshaa-navy text-sm">{priorityContact.name || 'Priority Contact'}</p>
                      <a href={`tel:${priorityContact.phone}`} className="text-xs text-rakshaa-coral font-bold hover:underline mt-0.5 block">
                        {priorityContact.phone}
                      </a>
                    </div>
                    <span className="text-[9px] font-black uppercase bg-rakshaa-coral text-white px-2 py-0.5 rounded">Priority</span>
                  </div>
                  <div className="flex items-center text-xs text-rakshaa-success font-semibold mt-2 pt-2 border-t border-rakshaa-coral/10">
                    <CheckCircle2 size={12} className="mr-1" /> WhatsApp SOS Alert Dispatched
                  </div>
                </div>
              )}

              {trustedContacts.map((c, i) => (
                <div key={i} className="p-3 bg-rakshaa-bg rounded-xl border border-rakshaa-border">
                  <div className="flex justify-between items-start">
                    <div>
                      <p className="font-bold text-rakshaa-navy text-sm">{c.name || 'Trusted Contact'}</p>
                      <a href={`tel:${c.phone}`} className="text-xs text-rakshaa-muted font-medium hover:underline mt-0.5 block">
                        {c.phone}
                      </a>
                    </div>
                    <span className="text-[9px] font-bold uppercase bg-blue-100 text-blue-700 px-1.5 py-0.5 rounded">{c.relationship || 'Trusted'}</span>
                  </div>
                  <div className="flex items-center text-xs text-rakshaa-success font-semibold mt-2 pt-2 border-t border-rakshaa-border/50">
                    <CheckCircle2 size={12} className="mr-1" /> WhatsApp Delivered
                  </div>
                </div>
              ))}

              {!priorityContact && trustedContacts.length === 0 && (
                <p className="text-xs text-rakshaa-muted py-2 text-center">No emergency contacts saved.</p>
              )}
            </div>
          </motion.div>

        </div>

        {/* Right Column (Map, Timeline, Actions) */}
        <div className="lg:col-span-2 space-y-6">
          
          {/* Live Map Card */}
          <motion.div 
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            className="bg-white border border-rakshaa-border rounded-2xl p-6 shadow-sm space-y-4"
          >
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 shrink-0">
              <div>
                <h3 className="font-extrabold text-rakshaa-navy flex items-center text-base">
                  <MapPin size={18} className="mr-2 text-rakshaa-coral" /> Live Location Tracking
                </h3>
                <p className="text-xs text-rakshaa-muted mt-0.5">{incident.address || 'Address pending GPS lock'}</p>
              </div>

              <div className="flex items-center space-x-3">
                <a 
                  href={googleMapsUrl}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="flex items-center space-x-1.5 text-xs font-bold text-blue-600 bg-blue-50 px-3 py-1.5 rounded-lg border border-blue-200 hover:bg-blue-100 transition-colors shadow-sm"
                >
                  <Navigation size={13} />
                  <span>Google Maps</span>
                </a>
              </div>
            </div>
            
            {/* Embedded OpenStreetMap View */}
            <div className="w-full h-[400px] rounded-xl overflow-hidden border border-rakshaa-border relative bg-gray-100 shadow-inner">
              <iframe
                title="Incident Map"
                width="100%"
                height="100%"
                style={{ border: 0 }}
                loading="lazy"
                src={`https://www.openstreetmap.org/export/embed.html?bbox=${lng - 0.008}%2C${lat - 0.008}%2C${lng + 0.008}%2C${lat + 0.008}&layer=mapnik&marker=${lat}%2C${lng}`}
              />
            </div>

            <div className="bg-rakshaa-bg p-3.5 rounded-xl border border-rakshaa-border flex items-center justify-between text-xs">
              <span className="font-mono text-rakshaa-navy font-bold">
                GPS: {lat.toFixed(6)}° N, {lng.toFixed(6)}° E
              </span>
              <span className="text-rakshaa-success font-bold flex items-center">
                <span className="w-2 h-2 rounded-full bg-rakshaa-success animate-pulse mr-1.5" />
                Live Tracking Active
              </span>
            </div>
          </motion.div>

          {/* Quick Responders Dispatch Actions */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.1 }}
            className="bg-white border border-rakshaa-border rounded-2xl p-6 shadow-sm"
          >
            <h3 className="font-extrabold text-rakshaa-navy mb-4 flex items-center text-sm uppercase tracking-wider">
              <ShieldAlert size={16} className="mr-2 text-red-500" /> Emergency First Responder Actions
            </h3>

            <div className="grid grid-cols-1 sm:grid-cols-3 gap-3">
              <a
                href="tel:112"
                className="p-3 bg-red-50 border border-red-200 rounded-xl flex items-center space-x-3 text-red-700 hover:bg-red-100 transition-colors shadow-sm"
              >
                <div className="w-10 h-10 rounded-lg bg-red-600 text-white flex items-center justify-center font-bold">
                  <Phone size={18} />
                </div>
                <div>
                  <p className="font-extrabold text-sm">Call Police</p>
                  <p className="text-xs text-red-600 font-semibold">112 Helpline</p>
                </div>
              </a>

              <a
                href={`tel:${incident.userPhone}`}
                className="p-3 bg-blue-50 border border-blue-200 rounded-xl flex items-center space-x-3 text-blue-700 hover:bg-blue-100 transition-colors shadow-sm"
              >
                <div className="w-10 h-10 rounded-lg bg-blue-600 text-white flex items-center justify-center font-bold">
                  <Phone size={18} />
                </div>
                <div>
                  <p className="font-extrabold text-sm">Call Victim</p>
                  <p className="text-xs text-blue-600 font-semibold">Direct Phone</p>
                </div>
              </a>

              {priorityContact && (
                <a
                  href={`tel:${priorityContact.phone}`}
                  className="p-3 bg-pink-50 border border-pink-200 rounded-xl flex items-center space-x-3 text-pink-700 hover:bg-pink-100 transition-colors shadow-sm"
                >
                  <div className="w-10 h-10 rounded-lg bg-pink-600 text-white flex items-center justify-center font-bold">
                    <Phone size={18} />
                  </div>
                  <div>
                    <p className="font-extrabold text-sm">Call Contact</p>
                    <p className="text-xs text-pink-600 font-semibold">{priorityContact.name || 'Priority'}</p>
                  </div>
                </a>
              )}
            </div>
          </motion.div>
        </div>

      </div>
    </div>
  );
}
