"use client";

import { motion, AnimatePresence } from 'framer-motion';
import { 
  Search,
  Filter,
  AlertTriangle,
  Clock,
  MapPin,
  Users,
  MessageCircle,
  Phone,
  ChevronRight,
  X,
  ExternalLink,
  ShieldAlert,
  CheckCircle2,
  Copy,
  Check,
  Radio,
  RefreshCw,
  User,
  ShieldCheck,
  Send,
  Navigation
} from 'lucide-react';
import Link from 'next/link';
import { useState, useEffect } from 'react';
import { collection, query, where, onSnapshot, doc, updateDoc, getDoc } from 'firebase/firestore';
import { db } from '@/lib/firebase';

interface EmergencyIncident {
  id: string;
  userId?: string;
  userName?: string;
  userPhone?: string;
  status: string;
  startedAt?: any;
  resolvedAt?: any;
  latitude?: number;
  longitude?: number;
  address?: string;
  notifiedCount?: number;
}

export default function LiveEmergenciesPage() {
  const [emergencies, setEmergencies] = useState<EmergencyIncident[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedIncident, setSelectedIncident] = useState<EmergencyIncident | null>(null);
  const [statusFilter, setStatusFilter] = useState<'all' | 'active'>('active');

  useEffect(() => {
    const q = statusFilter === 'active'
      ? query(collection(db, 'emergencies'), where('status', '==', 'active'))
      : collection(db, 'emergencies');

    const unsubscribe = onSnapshot(q, (snapshot) => {
      const emData: EmergencyIncident[] = [];
      snapshot.forEach((docSnap) => {
        emData.push({ id: docSnap.id, ...docSnap.data() } as EmergencyIncident);
      });
      // Sort by startedAt descending
      emData.sort((a, b) => {
        const timeA = a.startedAt?.toMillis ? a.startedAt.toMillis() : (a.startedAt ? new Date(a.startedAt).getTime() : 0);
        const timeB = b.startedAt?.toMillis ? b.startedAt.toMillis() : (b.startedAt ? new Date(b.startedAt).getTime() : 0);
        return timeB - timeA;
      });
      setEmergencies(emData);
      setLoading(false);
    });

    return () => unsubscribe();
  }, [statusFilter]);

  const filteredEmergencies = emergencies.filter((em) => {
    const query = searchQuery.toLowerCase();
    const nameMatch = (em.userName || '').toLowerCase().includes(query);
    const phoneMatch = (em.userPhone || '').toLowerCase().includes(query);
    const idMatch = (em.id || '').toLowerCase().includes(query);
    const addressMatch = (em.address || '').toLowerCase().includes(query);
    return nameMatch || phoneMatch || idMatch || addressMatch;
  });

  return (
    <div className="space-y-6 max-w-7xl mx-auto min-h-full pb-16">
      {/* Header & Controls */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
          <h2 className="text-2xl font-black text-rakshaa-navy flex items-center tracking-tight">
            <ShieldAlert className="mr-2 text-rakshaa-coral" size={26} />
            Live Emergencies Command
            <span className="ml-3 bg-rakshaa-coral/10 text-rakshaa-coral border border-rakshaa-coral/20 text-xs px-3 py-1 rounded-full font-bold flex items-center">
              <span className="w-2 h-2 rounded-full bg-rakshaa-coral animate-ping mr-1.5" />
              {emergencies.filter(e => e.status === 'active').length} ACTIVE
            </span>
          </h2>
          <p className="text-rakshaa-muted mt-1 text-sm">
            Real-time SOS incident monitoring, live GPS tracking, and safety response dispatch.
          </p>
        </div>
        
        <div className="flex items-center space-x-3">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-rakshaa-muted" size={17} />
            <input 
              type="text" 
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              placeholder="Search user, ID, phone..." 
              className="pl-9 pr-4 py-2 border border-rakshaa-border rounded-xl bg-white text-sm focus:outline-none focus:ring-2 focus:ring-rakshaa-coral/40 w-60 shadow-sm"
            />
          </div>
          
          <button 
            onClick={() => setStatusFilter(prev => prev === 'active' ? 'all' : 'active')}
            className={`flex items-center space-x-2 px-3.5 py-2 border rounded-xl text-sm font-semibold transition-all shadow-sm ${
              statusFilter === 'active' 
                ? 'bg-rakshaa-coral/10 border-rakshaa-coral/30 text-rakshaa-coral' 
                : 'bg-white border-rakshaa-border text-rakshaa-navy hover:bg-rakshaa-bg'
            }`}
          >
            <Filter size={16} />
            <span>{statusFilter === 'active' ? 'Active Only' : 'All Incidents'}</span>
          </button>
        </div>
      </div>

      {/* Emergency Cards Grid */}
      {loading ? (
        <div className="flex flex-col items-center justify-center py-20 text-rakshaa-muted">
          <RefreshCw className="animate-spin mb-3 text-rakshaa-coral" size={32} />
          <p className="font-semibold text-sm">Connecting to Rakshaa Live Dispatch stream...</p>
        </div>
      ) : filteredEmergencies.length === 0 ? (
        <div className="flex flex-col items-center justify-center text-rakshaa-muted bg-white rounded-2xl border border-rakshaa-border border-dashed p-12 shadow-sm text-center">
          <div className="w-16 h-16 bg-rakshaa-success/10 text-rakshaa-success rounded-full flex items-center justify-center mb-4">
            <ShieldCheck size={36} />
          </div>
          <h3 className="text-xl font-extrabold text-rakshaa-navy">All Safe & Operational</h3>
          <p className="mt-2 text-sm text-rakshaa-muted max-w-md">
            {searchQuery 
              ? `No emergency incidents match your search "${searchQuery}".` 
              : 'There are currently no active SOS alerts triggered across the Rakshaa network.'}
          </p>
        </div>
      ) : (
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          {filteredEmergencies.map((em, index) => (
            <EmergencyCard 
              key={em.id}
              data={em}
              delay={index * 0.05}
              onOpenDetails={() => setSelectedIncident(em)}
            />
          ))}
        </div>
      )}

      {/* Interactive Emergency Incident Modal */}
      <AnimatePresence>
        {selectedIncident && (
          <IncidentDetailsModal 
            incident={selectedIncident} 
            onClose={() => setSelectedIncident(null)} 
          />
        )}
      </AnimatePresence>
    </div>
  );
}

function EmergencyCard({ 
  data, 
  delay, 
  onOpenDetails 
}: { 
  data: EmergencyIncident; 
  delay: number; 
  onOpenDetails: () => void; 
}) {
  const [duration, setDuration] = useState('0s');
  const [copied, setCopied] = useState(false);

  useEffect(() => {
    if (!data.startedAt) return;
    
    const startTime = data.startedAt.toMillis 
      ? data.startedAt.toMillis() 
      : (data.startedAt ? new Date(data.startedAt).getTime() : Date.now());
    
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
  }, [data.startedAt]);

  const copyId = (e: React.MouseEvent) => {
    e.stopPropagation();
    navigator.clipboard.writeText(data.id);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  const locationText = data.address && !data.address.includes('Acquir') && !data.address.includes('Locat')
    ? data.address
    : (data.latitude && data.longitude 
        ? `Lat: ${data.latitude.toFixed(5)}, Lng: ${data.longitude.toFixed(5)}`
        : 'Acquiring GPS fix...');

  const isActive = data.status === 'active';

  return (
    <motion.div 
      initial={{ opacity: 0, y: 15 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay, duration: 0.3 }}
      onClick={onOpenDetails}
      className={`bg-white rounded-2xl border-2 transition-all cursor-pointer shadow-sm hover:shadow-lg flex flex-col overflow-hidden group ${
        isActive 
          ? 'border-rakshaa-coral/30 hover:border-rakshaa-coral' 
          : 'border-rakshaa-border hover:border-rakshaa-navy/30 opacity-80'
      }`}
    >
      {/* Top Banner */}
      <div className={`px-5 py-3 border-b flex justify-between items-center ${
        isActive ? 'bg-rakshaa-coral/10 border-rakshaa-coral/15' : 'bg-gray-100 border-gray-200'
      }`}>
        <div className="flex items-center space-x-2.5">
          {isActive ? (
            <div className="relative flex h-3 w-3">
              <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-rakshaa-coral opacity-75"></span>
              <span className="relative inline-flex rounded-full h-3 w-3 bg-rakshaa-coral"></span>
            </div>
          ) : (
            <div className="w-2.5 h-2.5 rounded-full bg-rakshaa-success" />
          )}
          <span className={`text-xs font-black tracking-wider uppercase ${
            isActive ? 'text-rakshaa-coral' : 'text-gray-600'
          }`}>
            {isActive ? 'ACTIVE EMERGENCY' : 'RESOLVED INCIDENT'}
          </span>
        </div>

        <button 
          onClick={copyId}
          className="flex items-center space-x-1 text-xs font-mono text-rakshaa-muted hover:text-rakshaa-navy bg-white/70 px-2 py-0.5 rounded-md border border-black/5"
          title="Click to copy ID"
        >
          <span>{data.id.substring(0, 16)}...</span>
          {copied ? <Check size={12} className="text-rakshaa-success" /> : <Copy size={12} />}
        </button>
      </div>

      {/* Card Body */}
      <div className="p-5 flex-1 flex flex-col justify-between space-y-4">
        {/* User Info Header */}
        <div className="flex justify-between items-start gap-3">
          <div className="flex items-center space-x-3.5">
            <div className="w-12 h-12 rounded-xl bg-rakshaa-navy text-white flex items-center justify-center font-black text-lg shadow-sm shrink-0">
              {(data.userName || 'R').charAt(0).toUpperCase()}
            </div>
            <div>
              <div className="flex items-center space-x-2">
                <h3 className="text-lg font-black text-rakshaa-navy group-hover:text-rakshaa-coral transition-colors">
                  {data.userName || 'Rakshaa User'}
                </h3>
                <span className="bg-rakshaa-green/40 text-rakshaa-success text-[10px] font-bold px-2 py-0.5 rounded-full flex items-center">
                  <CheckCircle2 size={10} className="mr-0.5" /> Live SOS
                </span>
              </div>
              <a 
                href={`tel:${data.userPhone}`}
                onClick={(e) => e.stopPropagation()}
                className="text-xs font-semibold text-rakshaa-muted hover:text-rakshaa-coral flex items-center mt-1 transition-colors"
              >
                <Phone size={12} className="mr-1 text-rakshaa-coral" /> 
                {data.userPhone || 'No Phone Registered'}
              </a>
            </div>
          </div>

          <div className="text-right shrink-0">
            <div className="flex items-center text-rakshaa-coral font-black text-sm bg-rakshaa-coral/10 px-2.5 py-1 rounded-lg border border-rakshaa-coral/20">
              <Clock size={14} className="mr-1" /> {duration}
            </div>
            <p className="text-[10px] font-medium text-rakshaa-muted mt-1 uppercase tracking-wider">Elapsed Time</p>
          </div>
        </div>

        {/* Location & Network Badges */}
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
          {/* Location Block */}
          <div className="bg-rakshaa-bg p-3 rounded-xl border border-rakshaa-border flex flex-col justify-between">
            <div className="flex items-center text-[11px] font-bold text-rakshaa-muted uppercase tracking-wider mb-1">
              <MapPin size={13} className="mr-1 text-rakshaa-coral" /> Live Location
            </div>
            <p className="font-semibold text-rakshaa-navy text-xs line-clamp-2" title={locationText}>
              {locationText}
            </p>
            <div className="flex items-center text-[10px] text-rakshaa-success font-semibold mt-1.5">
              <span className="w-1.5 h-1.5 rounded-full bg-rakshaa-success animate-pulse mr-1" />
              GPS Locked & Streaming
            </div>
          </div>

          {/* Safety Network Block */}
          <div className="bg-rakshaa-bg p-3 rounded-xl border border-rakshaa-border flex flex-col justify-between">
            <div className="flex items-center text-[11px] font-bold text-rakshaa-muted uppercase tracking-wider mb-1">
              <Users size={13} className="mr-1 text-blue-500" /> Contacts & WhatsApp
            </div>
            <p className="font-bold text-rakshaa-navy text-xs">
              {data.notifiedCount || 0} Contacts Notified
            </p>
            <div className="flex items-center text-[10px] text-blue-600 font-semibold mt-1.5">
              <MessageCircle size={11} className="mr-1" />
              WhatsApp Alerts Broadcast
            </div>
          </div>
        </div>

        {/* Footer Actions */}
        <div className="pt-3 border-t border-rakshaa-border flex flex-wrap items-center justify-between gap-2">
          <button 
            onClick={(e) => {
              e.stopPropagation();
              onOpenDetails();
            }}
            className="flex items-center space-x-1.5 text-xs font-bold text-rakshaa-navy hover:text-rakshaa-coral transition-colors"
          >
            <span>Click to View Full Details</span>
            <ChevronRight size={14} />
          </button>

          <div className="flex items-center space-x-2">
            {data.latitude && data.longitude && (
              <a 
                href={`https://www.google.com/maps/search/?api=1&query=${data.latitude},${data.longitude}`}
                target="_blank"
                rel="noopener noreferrer"
                onClick={(e) => e.stopPropagation()}
                className="flex items-center space-x-1 bg-blue-500/10 text-blue-600 border border-blue-500/20 px-3 py-1.5 rounded-lg text-xs font-bold hover:bg-blue-500 hover:text-white transition-all shadow-sm"
              >
                <Navigation size={12} />
                <span>Map</span>
              </a>
            )}

            {isActive && (
              <button 
                onClick={async (e) => {
                  e.stopPropagation();
                  if (confirm(`Mark emergency ${data.id} as resolved?`)) {
                    await updateDoc(doc(db, 'emergencies', data.id), { 
                      status: 'resolved',
                      resolvedAt: new Date()
                    });
                  }
                }}
                className="flex items-center space-x-1 bg-rakshaa-success/10 text-rakshaa-success border border-rakshaa-success/30 px-3 py-1.5 rounded-lg text-xs font-bold hover:bg-rakshaa-success hover:text-white transition-all shadow-sm"
              >
                <CheckCircle2 size={12} />
                <span>Resolve</span>
              </button>
            )}
          </div>
        </div>
      </div>
    </motion.div>
  );
}

function IncidentDetailsModal({ 
  incident, 
  onClose 
}: { 
  incident: EmergencyIncident; 
  onClose: () => void; 
}) {
  const [userDetails, setUserDetails] = useState<any>(null);
  const [loadingUser, setLoadingUser] = useState(true);
  const [resolving, setResolving] = useState(false);

  useEffect(() => {
    async function fetchUser() {
      if (!incident.userId) {
        setLoadingUser(false);
        return;
      }
      try {
        const userSnap = await getDoc(doc(db, 'users', incident.userId));
        if (userSnap.exists()) {
          setUserDetails(userSnap.data());
        }
      } catch (e) {
        console.error("Error fetching user:", e);
      } finally {
        setLoadingUser(false);
      }
    }
    fetchUser();
  }, [incident.userId]);

  const handleResolve = async () => {
    if (!confirm('Are you sure you want to mark this emergency as RESOLVED?')) return;
    setResolving(true);
    try {
      await updateDoc(doc(db, 'emergencies', incident.id), { 
        status: 'resolved',
        resolvedAt: new Date()
      });
      onClose();
    } catch (e) {
      alert("Error resolving emergency: " + e);
    } finally {
      setResolving(false);
    }
  };

  const lat = incident.latitude || 28.6139;
  const lng = incident.longitude || 77.2090;
  const googleMapsUrl = `https://www.google.com/maps/search/?api=1&query=${lat},${lng}`;

  const priorityContact = userDetails?.priorityContact;
  const trustedContacts: any[] = userDetails?.trustedContacts || [];

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 sm:p-6 overflow-y-auto">
      {/* Backdrop */}
      <motion.div 
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        exit={{ opacity: 0 }}
        onClick={onClose}
        className="fixed inset-0 bg-rakshaa-navy/80 backdrop-blur-sm"
      />

      {/* Modal Dialog */}
      <motion.div 
        initial={{ opacity: 0, scale: 0.95, y: 20 }}
        animate={{ opacity: 1, scale: 1, y: 0 }}
        exit={{ opacity: 0, scale: 0.95, y: 20 }}
        className="relative w-full max-w-4xl bg-white rounded-3xl shadow-2xl border border-white/20 overflow-hidden z-10 flex flex-col max-h-[90vh]"
      >
        {/* Modal Header */}
        <div className="bg-rakshaa-navy text-white px-6 py-4 flex items-center justify-between border-b border-white/10 shrink-0">
          <div className="flex items-center space-x-3">
            <div className="w-10 h-10 rounded-xl bg-rakshaa-coral/20 border border-rakshaa-coral/40 flex items-center justify-center text-rakshaa-coral">
              <ShieldAlert size={22} />
            </div>
            <div>
              <div className="flex items-center space-x-2">
                <h2 className="font-extrabold text-lg tracking-wide">Emergency Incident Command</h2>
                <span className="bg-rakshaa-coral text-white text-[10px] font-black uppercase px-2.5 py-0.5 rounded-full">
                  {incident.status.toUpperCase()}
                </span>
              </div>
              <p className="text-xs text-white/60 font-mono mt-0.5">{incident.id}</p>
            </div>
          </div>

          <button 
            onClick={onClose}
            className="w-9 h-9 rounded-full bg-white/10 hover:bg-white/20 text-white flex items-center justify-center transition-colors"
          >
            <X size={18} />
          </button>
        </div>

        {/* Modal Body */}
        <div className="p-6 overflow-y-auto space-y-6 flex-1">
          {/* Top Info Cards */}
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            {/* Victim Info */}
            <div className="bg-rakshaa-bg p-4 rounded-2xl border border-rakshaa-border">
              <div className="flex items-center text-xs font-bold text-rakshaa-muted uppercase tracking-wider mb-2">
                <User size={14} className="mr-1.5 text-rakshaa-coral" /> User Details
              </div>
              <h4 className="font-black text-rakshaa-navy text-base">{incident.userName || 'Rakshaa User'}</h4>
              <p className="text-xs text-rakshaa-muted font-mono mt-0.5">UID: {incident.userId?.substring(0, 12)}...</p>
              
              <div className="mt-3 pt-3 border-t border-rakshaa-border/60 flex items-center justify-between">
                <a 
                  href={`tel:${incident.userPhone}`}
                  className="flex items-center space-x-1.5 text-xs font-bold text-rakshaa-coral hover:underline"
                >
                  <Phone size={13} />
                  <span>{incident.userPhone || 'Call Phone'}</span>
                </a>
              </div>
            </div>

            {/* Incident Timestamp */}
            <div className="bg-rakshaa-bg p-4 rounded-2xl border border-rakshaa-border">
              <div className="flex items-center text-xs font-bold text-rakshaa-muted uppercase tracking-wider mb-2">
                <Clock size={14} className="mr-1.5 text-blue-500" /> Incident Timing
              </div>
              <p className="font-bold text-rakshaa-navy text-sm">
                {incident.startedAt?.toDate 
                  ? incident.startedAt.toDate().toLocaleString() 
                  : (incident.startedAt ? new Date(incident.startedAt).toLocaleString() : 'Live Ongoing')}
              </p>
              <div className="mt-3 pt-3 border-t border-rakshaa-border/60">
                <span className="text-xs font-bold text-rakshaa-success flex items-center">
                  <span className="w-2 h-2 rounded-full bg-rakshaa-success animate-pulse mr-1.5" />
                  Real-Time Live Active Session
                </span>
              </div>
            </div>

            {/* Quick Emergency Actions */}
            <div className="bg-rakshaa-bg p-4 rounded-2xl border border-rakshaa-border flex flex-col justify-between">
              <div className="flex items-center text-xs font-bold text-rakshaa-muted uppercase tracking-wider mb-2">
                <ShieldAlert size={14} className="mr-1.5 text-red-500" /> Direct Dialers
              </div>
              <div className="grid grid-cols-2 gap-2">
                <a 
                  href="tel:112"
                  className="bg-red-600 hover:bg-red-700 text-white py-2 px-3 rounded-xl text-xs font-bold text-center flex items-center justify-center space-x-1 shadow-sm transition-colors"
                >
                  <Phone size={13} />
                  <span>Call 112</span>
                </a>
                <a 
                  href={`tel:${incident.userPhone}`}
                  className="bg-rakshaa-navy hover:bg-rakshaa-navy/90 text-white py-2 px-3 rounded-xl text-xs font-bold text-center flex items-center justify-center space-x-1 shadow-sm transition-colors"
                >
                  <Phone size={13} />
                  <span>Call User</span>
                </a>
              </div>
            </div>
          </div>

          {/* Live Location Visualizer */}
          <div className="bg-white rounded-2xl border border-rakshaa-border p-5 shadow-sm space-y-3">
            <div className="flex items-center justify-between">
              <div className="flex items-center space-x-2">
                <MapPin className="text-rakshaa-coral" size={18} />
                <h3 className="font-black text-rakshaa-navy text-sm">Live GPS & Resolved Address</h3>
              </div>
              <a 
                href={googleMapsUrl}
                target="_blank"
                rel="noopener noreferrer"
                className="flex items-center space-x-1 text-xs font-bold text-blue-600 hover:text-blue-700 bg-blue-50 px-3 py-1.5 rounded-lg border border-blue-200 transition-colors"
              >
                <ExternalLink size={13} />
                <span>Open in Google Maps</span>
              </a>
            </div>

            <div className="p-3 bg-rakshaa-bg rounded-xl border border-rakshaa-border">
              <p className="font-bold text-rakshaa-navy text-sm">{incident.address || 'Resolving exact GPS address...'}</p>
              <p className="text-xs text-rakshaa-muted font-mono mt-1">
                Coordinates: {lat.toFixed(6)}° N, {lng.toFixed(6)}° E
              </p>
            </div>

            {/* Embedded OpenStreetMap View */}
            <div className="w-full h-56 rounded-xl overflow-hidden border border-rakshaa-border relative bg-gray-100">
              <iframe
                title="Incident Location Map"
                width="100%"
                height="100%"
                style={{ border: 0 }}
                loading="lazy"
                src={`https://www.openstreetmap.org/export/embed.html?bbox=${lng - 0.005}%2C${lat - 0.005}%2C${lng + 0.005}%2C${lat + 0.005}&layer=mapnik&marker=${lat}%2C${lng}`}
              />
            </div>
          </div>

          {/* Safety Network & Notified Contacts */}
          <div className="bg-white rounded-2xl border border-rakshaa-border p-5 shadow-sm space-y-4">
            <div className="flex items-center justify-between">
              <div className="flex items-center space-x-2">
                <Users className="text-blue-500" size={18} />
                <h3 className="font-black text-rakshaa-navy text-sm">Notified Emergency Contacts & WhatsApp Delivery</h3>
              </div>
              <span className="text-xs font-bold text-rakshaa-muted bg-rakshaa-bg px-2.5 py-1 rounded-lg">
                {(priorityContact ? 1 : 0) + trustedContacts.length} Total Contacts
              </span>
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
              {/* Priority Contact */}
              {priorityContact && (
                <div className="p-3 bg-rakshaa-coral/5 rounded-xl border border-rakshaa-coral/20 flex justify-between items-center">
                  <div>
                    <div className="flex items-center space-x-1.5">
                      <span className="font-black text-rakshaa-navy text-sm">{priorityContact.name || 'Priority Contact'}</span>
                      <span className="text-[9px] font-black uppercase bg-rakshaa-coral text-white px-1.5 py-0.5 rounded">Priority</span>
                    </div>
                    <p className="text-xs text-rakshaa-muted mt-0.5">{priorityContact.phone}</p>
                    <p className="text-[10px] text-rakshaa-success font-bold mt-1 flex items-center">
                      <CheckCircle2 size={10} className="mr-1" /> WhatsApp Alert Dispatched
                    </p>
                  </div>
                  <a 
                    href={`tel:${priorityContact.phone}`}
                    className="w-9 h-9 rounded-xl bg-rakshaa-coral text-white flex items-center justify-center shadow-sm hover:opacity-90 transition-opacity"
                  >
                    <Phone size={15} />
                  </a>
                </div>
              )}

              {/* Trusted Contacts */}
              {trustedContacts.map((c, i) => (
                <div key={i} className="p-3 bg-rakshaa-bg rounded-xl border border-rakshaa-border flex justify-between items-center">
                  <div>
                    <div className="flex items-center space-x-1.5">
                      <span className="font-bold text-rakshaa-navy text-sm">{c.name || 'Trusted Contact'}</span>
                      <span className="text-[9px] font-bold uppercase bg-blue-100 text-blue-700 px-1.5 py-0.5 rounded">{c.relationship || 'Trusted'}</span>
                    </div>
                    <p className="text-xs text-rakshaa-muted mt-0.5">{c.phone}</p>
                    <p className="text-[10px] text-rakshaa-success font-bold mt-1 flex items-center">
                      <CheckCircle2 size={10} className="mr-1" /> WhatsApp Delivered
                    </p>
                  </div>
                  <a 
                    href={`tel:${c.phone}`}
                    className="w-9 h-9 rounded-xl bg-rakshaa-navy text-white flex items-center justify-center shadow-sm hover:opacity-90 transition-opacity"
                  >
                    <Phone size={15} />
                  </a>
                </div>
              ))}

              {!priorityContact && trustedContacts.length === 0 && (
                <div className="col-span-2 text-center py-4 text-xs text-rakshaa-muted">
                  No additional emergency contacts configured for this user profile.
                </div>
              )}
            </div>
          </div>
        </div>

        {/* Modal Footer */}
        <div className="bg-rakshaa-bg px-6 py-4 border-t border-rakshaa-border flex items-center justify-between shrink-0">
          <Link href={`/admin/users/${incident.userId || ''}`}>
            <button className="flex items-center space-x-1.5 text-xs font-bold text-rakshaa-navy hover:underline">
              <span>View User Safety Profile</span>
              <ChevronRight size={14} />
            </button>
          </Link>

          <div className="flex items-center space-x-3">
            <button 
              onClick={onClose}
              className="px-4 py-2 bg-white border border-rakshaa-border rounded-xl text-xs font-bold text-rakshaa-navy hover:bg-gray-50 transition-colors shadow-sm"
            >
              Close
            </button>

            {incident.status === 'active' && (
              <button 
                onClick={handleResolve}
                disabled={resolving}
                className="px-5 py-2 bg-rakshaa-success text-white rounded-xl text-xs font-black hover:bg-rakshaa-success/90 transition-colors shadow-sm flex items-center space-x-1.5"
              >
                <CheckCircle2 size={14} />
                <span>{resolving ? 'Resolving...' : 'Mark Incident Resolved'}</span>
              </button>
            )}
          </div>
        </div>
      </motion.div>
    </div>
  );
}
