"use client";

import { motion } from 'framer-motion';
import { 
  ArrowLeft,
  MessageCircle,
  MoreVertical,
  CheckCircle2,
  Shield,
  Calendar,
  Phone,
  Mail,
  User,
  MapPin,
  Clock,
  AlertTriangle,
  Bell,
  Smartphone,
  Timer,
  Edit3,
  FileText
} from 'lucide-react';
import Link from 'next/link';
import { use, Suspense, useState, useEffect } from 'react';
import { doc, getDoc, collection, query, where, getDocs, orderBy } from 'firebase/firestore';
import { db } from '@/lib/firebase';

export default function UserDetailsPage({ params }: { params: Promise<{ id: string }> }) {
  return (
    <Suspense fallback={<div className="p-8 text-center text-rakshaa-muted">Loading details...</div>}>
      <UserDetailsContent params={params} />
    </Suspense>
  );
}

function UserDetailsContent({ params }: { params: Promise<{ id: string }> }) {
  const resolvedParams = use(params);
  const [activeTab, setActiveTab] = useState('Overview');
  const [user, setUser] = useState<any>(null);
  const [emergencies, setEmergencies] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchData = async () => {
      try {
        // Fetch User
        const docRef = doc(db, 'users', resolvedParams.id);
        const docSnap = await getDoc(docRef);
        if (docSnap.exists()) {
          setUser({ id: docSnap.id, ...docSnap.data() });
        }
        
        // Fetch Emergencies
        const emergenciesRef = collection(db, 'emergencies');
        const q = query(emergenciesRef, where('userId', '==', resolvedParams.id), orderBy('startedAt', 'desc'));
        const querySnapshot = await getDocs(q);
        const emergencyList = querySnapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
        setEmergencies(emergencyList);

      } catch (error) {
        console.error("Error fetching data:", error);
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, [resolvedParams.id]);

  if (loading) {
    return <div className="p-8 text-center text-rakshaa-muted min-h-screen flex items-center justify-center">Loading user details...</div>;
  }

  if (!user) {
    return <div className="p-8 text-center text-rakshaa-danger min-h-screen flex items-center justify-center font-bold">User not found.</div>;
  }

  const joinDate = user.createdAt ? (user.createdAt.toDate ? user.createdAt.toDate().toLocaleDateString() : new Date(user.createdAt).toLocaleDateString()) : 'N/A';
  const hasContacts = user.trustedContacts && user.trustedContacts.length > 0;
  const initials = user.fullName ? user.fullName.split(' ').map((n: string) => n[0]).join('').substring(0, 2).toUpperCase() : 'UU';
  
  const tabs = ['Overview', 'Emergency Contacts', 'Emergency History', 'Notifications', 'Location History', 'Safety Setup'];

  return (
    <motion.div 
      initial={{ x: '100%', opacity: 0 }}
      animate={{ x: 0, opacity: 1 }}
      exit={{ x: '100%', opacity: 0 }}
      transition={{ type: 'spring', damping: 25, stiffness: 200 }}
      className="bg-rakshaa-bg min-h-full pb-12"
    >
      <div className="max-w-7xl mx-auto space-y-6">
        
        {/* Header */}
        <div className="flex items-center justify-between bg-white p-4 rounded-xl border border-rakshaa-border shadow-sm">
          <div className="flex items-center space-x-4">
            <Link href="/admin/users">
              <button className="p-2 hover:bg-rakshaa-bg rounded-full transition-colors text-rakshaa-navy">
                <ArrowLeft size={20} />
              </button>
            </Link>
            <h2 className="text-xl font-bold text-rakshaa-navy">User Details</h2>
          </div>
          <div className="flex items-center space-x-3">
            <button className="flex items-center space-x-2 px-4 py-2 bg-rakshaa-coral/10 text-rakshaa-coral rounded-lg font-medium hover:bg-rakshaa-coral/20 transition-colors text-sm border border-rakshaa-coral/20">
              <MessageCircle size={16} />
              <span>Send Message</span>
            </button>
            <button className="p-2 text-rakshaa-muted hover:bg-rakshaa-bg rounded-full transition-colors">
              <MoreVertical size={20} />
            </button>
          </div>
        </div>

        {/* Profile Card */}
        <div className="bg-white p-6 rounded-xl border border-rakshaa-border shadow-sm flex flex-col md:flex-row justify-between items-start md:items-center gap-6">
          <div className="flex items-center space-x-5">
            <div className="w-20 h-20 bg-rakshaa-blush rounded-full flex items-center justify-center border-4 border-white shadow-sm overflow-hidden shrink-0">
              {/* Fake Avatar */}
              <div className="w-full h-full bg-rakshaa-navy flex items-center justify-center text-white font-bold text-2xl">
                {initials}
              </div>
            </div>
            <div>
              <div className="flex items-center space-x-3">
                <h3 className="text-2xl font-bold text-rakshaa-navy">{user.fullName || 'Unknown User'}</h3>
                <span className="bg-rakshaa-success/10 text-rakshaa-success px-2 py-0.5 rounded text-xs font-bold flex items-center">
                  <CheckCircle2 size={12} className="mr-1" /> Active
                </span>
              </div>
              <div className="flex flex-col sm:flex-row sm:items-center text-sm text-rakshaa-muted mt-2 space-y-1 sm:space-y-0 sm:space-x-6">
                <span className="flex items-center"><Phone size={14} className="mr-1.5" /> {user.mobileNumber || 'N/A'}</span>
                <span className="flex items-center"><Mail size={14} className="mr-1.5" /> {user.email || 'N/A'}</span>
              </div>
            </div>
          </div>
          
          <div className="bg-rakshaa-bg p-4 rounded-lg border border-rakshaa-border text-sm space-y-2 min-w-[200px]">
            <div className="flex justify-between">
              <span className="text-rakshaa-muted">User ID:</span>
              <span className="font-semibold text-rakshaa-navy truncate max-w-[120px]" title={user.id}>{user.id}</span>
            </div>
            <div className="flex justify-between">
              <span className="text-rakshaa-muted">Joined:</span>
              <span className="font-semibold text-rakshaa-navy">{joinDate}</span>
            </div>
            <div className="flex justify-between">
              <span className="text-rakshaa-muted">Last Active:</span>
              <span className="font-semibold text-rakshaa-navy">Just now</span>
            </div>
          </div>
        </div>

        {/* Tabs */}
        <div className="border-b border-rakshaa-border flex space-x-8 overflow-x-auto scrollbar-hide px-2">
          {tabs.map(tab => (
            <Tab key={tab} active={activeTab === tab} onClick={() => setActiveTab(tab)}>{tab}</Tab>
          ))}
        </div>

        {activeTab === 'Overview' && (
          <motion.div 
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            className="space-y-6"
          >
            {/* 4 Stat Cards */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          <StatCard 
            icon={<AlertTriangle className="text-rakshaa-coral" size={24} />}
            bg="bg-rakshaa-coral/10"
            title="Total Emergencies"
            value={emergencies.length.toString()}
            subtitle="All time"
            trend=""
            trendColor="text-rakshaa-coral"
          />
          <StatCard 
            icon={<Shield className="text-rakshaa-success" size={24} />}
            bg="bg-rakshaa-success/10"
            title="Safety Score"
            value="85%"
            subtitle="Profile completion"
            trend={<CheckCircle2 size={14} className="text-rakshaa-success" />}
          />
          <StatCard 
            icon={<User className="text-blue-500" size={24} />}
            bg="bg-blue-500/10"
            title="Emergency Contacts"
            value={user.trustedContacts?.length || 0}
            subtitle="Added"
            trend=""
          />
          <StatCard 
            icon={<Calendar className="text-purple-500" size={24} />}
            bg="bg-purple-500/10"
            title="Safety Tools Used"
            value="2"
            subtitle="This month"
            trend=""
          />
        </div>

        {/* Main Dashboard Grid */}
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          
          {/* Column 1 */}
          <div className="space-y-6">
            
            {/* Basic Information */}
            <div className="bg-white border border-rakshaa-border rounded-xl p-5 shadow-sm">
              <div className="flex items-center justify-between mb-4">
                <h4 className="font-bold text-rakshaa-navy flex items-center text-sm">
                  <User size={16} className="mr-2 text-rakshaa-coral" /> Basic Information
                </h4>
                <button className="text-xs text-blue-500 font-medium flex items-center">
                  <Edit3 size={12} className="mr-1" /> Edit
                </button>
              </div>
              
              <div className="space-y-4 text-sm">
                <div>
                  <p className="text-rakshaa-muted text-xs">Full Name</p>
                  <p className="font-semibold text-rakshaa-navy">{user.fullName || 'Unknown'}</p>
                </div>
                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <p className="text-rakshaa-muted text-xs">Age</p>
                    <p className="font-semibold text-rakshaa-navy">{user.age || 'N/A'}</p>
                  </div>
                  <div>
                    <p className="text-rakshaa-muted text-xs">Gender</p>
                    <p className="font-semibold text-rakshaa-navy">{user.gender || 'N/A'}</p>
                  </div>
                </div>
                <div>
                  <p className="text-rakshaa-muted text-xs">Email Address</p>
                  <p className="font-semibold text-rakshaa-navy">{user.email || 'N/A'}</p>
                </div>
                <div>
                  <p className="text-rakshaa-muted text-xs">Mobile Number</p>
                  <p className="font-semibold text-rakshaa-navy">{user.mobileNumber || 'N/A'}</p>
                </div>
                <div>
                  <p className="text-rakshaa-muted text-xs">Address</p>
                  <p className="font-semibold text-rakshaa-navy">{user.address || 'N/A'}</p>
                </div>
                <div>
                  <p className="text-rakshaa-muted text-xs">Registration Date</p>
                  <p className="font-semibold text-rakshaa-navy">{joinDate}</p>
                </div>
              </div>
            </div>

            {/* Location */}
            <div className="bg-white border border-rakshaa-border rounded-xl p-5 shadow-sm">
              <div className="flex items-center justify-between mb-4">
                <h4 className="font-bold text-rakshaa-navy flex items-center text-sm">
                  <MapPin size={16} className="mr-2 text-rakshaa-muted" /> Location <span className="text-xs font-normal text-rakshaa-muted ml-1">(Last Known)</span>
                </h4>
                <button className="text-xs text-blue-500 font-medium flex items-center">
                  <Edit3 size={12} className="mr-1" /> Edit
                </button>
              </div>
              
              <div className="bg-rakshaa-bg/50 rounded-lg border border-rakshaa-border p-4 mb-4 flex flex-col items-center justify-center text-center">
                <MapPin size={28} className={user.latitude ? "text-rakshaa-success mb-2" : "text-rakshaa-muted/40 mb-2"} />
                {user.latitude ? (
                  <div className="bg-rakshaa-success/10 text-rakshaa-success px-2 py-0.5 rounded text-[10px] font-bold border border-rakshaa-success/20 flex items-center mb-2">
                    <span className="w-1.5 h-1.5 bg-rakshaa-success rounded-full animate-pulse mr-1" /> Live Sync Active
                  </div>
                ) : (
                  <span className="text-xs text-rakshaa-muted font-medium mb-2">Location Sync Off</span>
                )}
                
                <p className="text-sm font-semibold text-rakshaa-navy mt-1">
                  {user.latitude ? 'Live Device Location' : (user.address || 'Address not provided')}
                </p>
                <p className="text-xs text-rakshaa-muted mt-1">
                  {user.latitude ? `Lat: ${user.latitude.toFixed(4)}, Lng: ${user.longitude.toFixed(4)}` : 'No coordinate data available'}
                </p>
              </div>
              
              {user.latitude && user.longitude ? (
                <a 
                  href={`https://www.google.com/maps/search/?api=1&query=${user.latitude},${user.longitude}`} 
                  target="_blank" 
                  rel="noopener noreferrer"
                  className="w-full py-2 bg-blue-500 text-white rounded-lg text-xs font-medium flex justify-center items-center hover:bg-blue-600 transition-colors shadow-sm"
                >
                  <MapPin size={14} className="mr-2" /> Open in Google Maps
                </a>
              ) : (
                <button disabled className="w-full py-2 border border-rakshaa-border rounded-lg text-xs font-medium text-rakshaa-muted flex justify-center items-center opacity-50 cursor-not-allowed">
                  <MapPin size={14} className="mr-2" /> Location Not Available
                </button>
              )}
            </div>
            
          </div>

          {/* Column 2 */}
          <div className="space-y-6">
            
            {/* Safety Status */}
            <div className="bg-white border border-rakshaa-border rounded-xl p-5 shadow-sm">
              <div className="flex items-center justify-between mb-4">
                <h4 className="font-bold text-rakshaa-navy flex items-center text-sm">
                  <Shield size={16} className="mr-2 text-rakshaa-coral" /> Safety Status
                </h4>
                <span className={`px-2 py-1 rounded text-xs font-bold flex items-center border ${hasContacts ? 'bg-rakshaa-success/10 text-rakshaa-success border-rakshaa-success/20' : 'bg-rakshaa-warning/10 text-rakshaa-warning border-rakshaa-warning/20'}`}>
                  {hasContacts ? <><CheckCircle2 size={12} className="mr-1" /> Ready</> : <><AlertTriangle size={12} className="mr-1" /> Incomplete</>}
                </span>
              </div>
              
              <p className="text-sm text-rakshaa-muted mb-6">
                {hasContacts ? 'Your account is protected and ready.' : 'Your account needs more setup.'}
              </p>
              
              <div className="space-y-4 text-sm">
                <div className="flex items-center justify-between">
                  <div className="flex items-center text-rakshaa-navy">
                    <CheckCircle2 size={16} className="text-rakshaa-success mr-3" /> Profile Completion
                  </div>
                  <span className="font-semibold text-rakshaa-success">100%</span>
                </div>
                <div className="flex items-center justify-between">
                  <div className="flex items-center text-rakshaa-navy">
                    <CheckCircle2 size={16} className="text-rakshaa-success mr-3" /> Mobile Verified
                  </div>
                  <span className="font-semibold text-rakshaa-success">Yes</span>
                </div>
                <div className="flex items-center justify-between">
                  <div className="flex items-center text-rakshaa-navy">
                    <CheckCircle2 size={16} className={`${user.priorityContact?.name ? 'text-rakshaa-success' : 'text-rakshaa-muted'} mr-3`} /> Priority Contact
                  </div>
                  <span className={`font-semibold ${user.priorityContact?.name ? 'text-rakshaa-success' : 'text-rakshaa-muted'}`}>
                    {user.priorityContact?.name ? 'Added' : 'Not Added'}
                  </span>
                </div>
                <div className="flex items-center justify-between">
                  <div className="flex items-center text-rakshaa-navy">
                    <CheckCircle2 size={16} className={`${hasContacts ? 'text-rakshaa-success' : 'text-rakshaa-muted'} mr-3`} /> Trusted Contacts
                  </div>
                  <span className={`font-semibold ${hasContacts ? 'text-rakshaa-success' : 'text-rakshaa-muted'}`}>
                    {user.trustedContacts?.length || 0} people
                  </span>
                </div>
                <div className="flex items-center justify-between">
                  <div className="flex items-center text-rakshaa-navy">
                    <CheckCircle2 size={16} className="text-rakshaa-success mr-3" /> Location Sharing
                  </div>
                  <span className="font-semibold text-rakshaa-success">Enabled</span>
                </div>
              </div>
            </div>

            {/* Emergency Summary */}
            <div className="bg-white border border-rakshaa-border rounded-xl p-5 shadow-sm">
              <div className="flex items-center justify-between mb-4">
                <h4 className="font-bold text-rakshaa-navy flex items-center text-sm">
                  <AlertTriangle size={16} className="mr-2 text-rakshaa-coral" /> Emergency Summary
                </h4>
              </div>
              
              <div className="flex items-center justify-center space-x-4 mb-6">
                <div className="w-12 h-12 bg-rakshaa-coral/10 text-rakshaa-coral rounded-full flex items-center justify-center">
                  <AlertTriangle size={24} />
                </div>
                <div>
                  <p className="text-2xl font-bold text-rakshaa-navy">{emergencies.length}</p>
                  <p className="text-xs text-rakshaa-muted">Total Emergencies</p>
                </div>
              </div>
              
              <div className="grid grid-cols-2 gap-2">
                <div className="bg-rakshaa-success/5 border border-rakshaa-success/20 rounded-lg p-3 text-center">
                  <Shield size={16} className="mx-auto text-rakshaa-success mb-1" />
                  <p className="text-lg font-bold text-rakshaa-success">{emergencies.filter(e => e.status === 'resolved').length}</p>
                  <p className="text-[10px] text-rakshaa-success uppercase font-semibold">Resolved</p>
                </div>
                <div className="bg-rakshaa-coral/5 border border-rakshaa-coral/20 rounded-lg p-3 text-center">
                  <AlertTriangle size={16} className="mx-auto text-rakshaa-coral mb-1" />
                  <p className="text-lg font-bold text-rakshaa-coral">{emergencies.filter(e => e.status === 'active').length}</p>
                  <p className="text-[10px] text-rakshaa-coral uppercase font-semibold">Active</p>
                </div>
              </div>
            </div>

          </div>

          {/* Column 3 */}
          <div className="space-y-6">
            
            {/* Recent Activity */}
            <div className="bg-white border border-rakshaa-border rounded-xl p-5 shadow-sm">
              <h4 className="font-bold text-rakshaa-navy flex items-center text-sm mb-6">
                <Clock size={16} className="mr-2 text-rakshaa-coral" /> Recent Activity
              </h4>
              
              <div className="space-y-6 border-l border-rakshaa-border/50 ml-3">
                <ActivityItem 
                  icon={<AlertTriangle size={14} className="text-purple-500" />}
                  bg="bg-purple-500/10"
                  title="Emergency Mode activated"
                  date="12 Apr 2025 • 10:45 AM"
                />
                <ActivityItem 
                  icon={<MapPin size={14} className="text-rakshaa-coral" />}
                  bg="bg-rakshaa-coral/10"
                  title="Location shared with contacts"
                  date="12 Apr 2025 • 10:44 AM"
                />
                <ActivityItem 
                  icon={<MessageCircle size={14} className="text-blue-500" />}
                  bg="bg-blue-500/10"
                  title="WhatsApp message sent"
                  date="12 Apr 2025 • 10:42 AM"
                />
                <ActivityItem 
                  icon={<Timer size={14} className="text-rakshaa-success" />}
                  bg="bg-rakshaa-success/10"
                  title="Safety timer completed"
                  date="10 Apr 2025 • 06:20 PM"
                />
              </div>
            </div>

            {/* Quick Actions */}
            <div className="bg-white border border-rakshaa-border rounded-xl p-5 shadow-sm">
              <h4 className="font-bold text-rakshaa-navy flex items-center text-sm mb-4">
                <Edit3 size={16} className="mr-2 text-rakshaa-coral" /> Quick Actions
              </h4>
              
              <div className="space-y-3">
                <button className="w-full flex items-center px-4 py-3 bg-rakshaa-coral/5 border border-rakshaa-coral/20 rounded-lg text-sm font-medium text-rakshaa-coral hover:bg-rakshaa-coral/10 transition-colors">
                  <Clock size={16} className="mr-3" /> View Emergency History
                </button>
                <button className="w-full flex items-center px-4 py-3 bg-rakshaa-success/5 border border-rakshaa-success/20 rounded-lg text-sm font-medium text-rakshaa-success hover:bg-rakshaa-success/10 transition-colors">
                  <MessageCircle size={16} className="mr-3" /> Send WhatsApp
                </button>
                <button className="w-full flex items-center px-4 py-3 bg-blue-500/5 border border-blue-500/20 rounded-lg text-sm font-medium text-blue-500 hover:bg-blue-500/10 transition-colors">
                  <MapPin size={16} className="mr-3" /> View Location
                </button>
                <button className="w-full flex items-center px-4 py-3 bg-purple-500/5 border border-purple-500/20 rounded-lg text-sm font-medium text-purple-500 hover:bg-purple-500/10 transition-colors">
                  <Edit3 size={16} className="mr-3" /> Add Note
                </button>
              </div>
            </div>

          </div>
        </div>
        </motion.div>
        )}

        {/* Other Tabs Content */}
        {/* Emergency Contacts Tab */}
        {activeTab === 'Emergency Contacts' && (
          <motion.div 
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            className="space-y-6"
          >
            {/* Priority Contact */}
            <div className="bg-white border border-rakshaa-border rounded-xl p-6 shadow-sm">
              <h3 className="text-lg font-bold text-rakshaa-navy mb-4 flex items-center">
                <Shield size={20} className="mr-2 text-rakshaa-coral" /> Priority Contact
              </h3>
              {user.priorityContact?.name ? (
                <div className="bg-rakshaa-bg rounded-lg border border-rakshaa-border p-4 flex items-center justify-between">
                  <div className="flex items-center space-x-4">
                    <div className="w-12 h-12 bg-rakshaa-coral/10 rounded-full flex items-center justify-center text-rakshaa-coral font-bold text-lg">
                      {user.priorityContact.name.charAt(0).toUpperCase()}
                    </div>
                    <div>
                      <p className="font-bold text-rakshaa-navy">{user.priorityContact.name}</p>
                      <p className="text-sm text-rakshaa-muted">{user.priorityContact.relationship || 'Emergency Contact'}</p>
                    </div>
                  </div>
                  <div className="flex items-center space-x-3">
                    <a href={`tel:\${user.priorityContact.phone}`} className="p-2 bg-blue-500/10 text-blue-500 rounded-lg hover:bg-blue-500/20 transition-colors">
                      <Phone size={18} />
                    </a>
                    <div className="text-right">
                      <p className="font-semibold text-rakshaa-navy">{user.priorityContact.phone}</p>
                      <span className="text-[10px] uppercase font-bold text-rakshaa-coral bg-rakshaa-coral/10 px-2 py-0.5 rounded">Priority</span>
                    </div>
                  </div>
                </div>
              ) : (
                <div className="bg-rakshaa-bg rounded-lg border border-rakshaa-border p-8 text-center text-rakshaa-muted">
                  <AlertTriangle size={24} className="mx-auto mb-2 opacity-50" />
                  <p>No priority contact added yet.</p>
                </div>
              )}
            </div>

            {/* Trusted Contacts */}
            <div className="bg-white border border-rakshaa-border rounded-xl p-6 shadow-sm">
              <div className="flex items-center justify-between mb-4">
                <h3 className="text-lg font-bold text-rakshaa-navy flex items-center">
                  <User size={20} className="mr-2 text-blue-500" /> Trusted Contacts ({user.trustedContacts?.length || 0})
                </h3>
              </div>
              
              {user.trustedContacts && user.trustedContacts.length > 0 ? (
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  {user.trustedContacts.map((contact: any, index: number) => (
                    <div key={index} className="bg-white rounded-lg border border-rakshaa-border p-4 flex items-center justify-between shadow-sm hover:border-rakshaa-muted transition-colors">
                      <div className="flex items-center space-x-3">
                        <div className="w-10 h-10 bg-blue-500/10 rounded-full flex items-center justify-center text-blue-500 font-bold">
                          {contact.name?.charAt(0).toUpperCase() || '?'}
                        </div>
                        <div>
                          <p className="font-bold text-rakshaa-navy text-sm">{contact.name}</p>
                          {contact.hasWhatsApp && (
                            <span className="text-[10px] text-rakshaa-success font-medium flex items-center mt-0.5">
                              <MessageCircle size={10} className="mr-1" /> WhatsApp Enabled
                            </span>
                          )}
                        </div>
                      </div>
                      <div className="flex items-center space-x-2">
                        <span className="text-sm font-semibold text-rakshaa-navy">{contact.phone}</span>
                        <a href={`tel:\${contact.phone}`} className="p-1.5 bg-rakshaa-bg text-rakshaa-muted rounded hover:text-blue-500 transition-colors">
                          <Phone size={14} />
                        </a>
                      </div>
                    </div>
                  ))}
                </div>
              ) : (
                <div className="bg-rakshaa-bg rounded-lg border border-rakshaa-border p-8 text-center text-rakshaa-muted">
                  <User size={24} className="mx-auto mb-2 opacity-50" />
                  <p>No trusted contacts added.</p>
                </div>
              )}
            </div>
          </motion.div>
        )}

        {/* Emergency History Tab */}
        {activeTab === 'Emergency History' && (
          <motion.div 
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            className="space-y-6"
          >
            <div className="bg-white border border-rakshaa-border rounded-xl p-6 shadow-sm">
              <h3 className="text-lg font-bold text-rakshaa-navy mb-6 flex items-center">
                <Clock size={20} className="mr-2 text-rakshaa-coral" /> Emergency History Log
              </h3>
              
              {emergencies.length > 0 ? (
                <div className="space-y-4">
                  {emergencies.map((em) => {
                    const isActive = em.status === 'active';
                    const date = em.startedAt?.toDate ? em.startedAt.toDate().toLocaleString() : new Date(em.startedAt).toLocaleString();
                    
                    return (
                      <div key={em.id} className="border border-rakshaa-border rounded-xl p-5 flex flex-col md:flex-row md:items-center justify-between gap-4">
                        <div className="flex items-start space-x-4">
                          <div className={`w-12 h-12 rounded-full flex items-center justify-center shrink-0 \${isActive ? 'bg-rakshaa-coral/10 text-rakshaa-coral' : 'bg-rakshaa-success/10 text-rakshaa-success'}`}>
                            {isActive ? <AlertTriangle size={24} /> : <Shield size={24} />}
                          </div>
                          <div>
                            <div className="flex items-center space-x-3 mb-1">
                              <h4 className="font-bold text-rakshaa-navy">SOS Triggered</h4>
                              <span className={`px-2 py-0.5 rounded text-[10px] uppercase font-bold \${isActive ? 'bg-rakshaa-coral text-white' : 'bg-rakshaa-bg text-rakshaa-muted border border-rakshaa-border'}`}>
                                {em.status}
                              </span>
                            </div>
                            <p className="text-sm text-rakshaa-muted flex items-center">
                              <Calendar size={14} className="mr-1.5" /> {date}
                            </p>
                            <div className="flex items-center mt-2 space-x-4 text-sm font-medium">
                              <span className="flex items-center text-blue-500">
                                <User size={14} className="mr-1" /> {em.notifiedCount || 0} Notified
                              </span>
                              {em.latitude && (
                                <span className="flex items-center text-rakshaa-navy">
                                  <MapPin size={14} className="mr-1 text-rakshaa-muted" /> Location tracked
                                </span>
                              )}
                            </div>
                          </div>
                        </div>
                        <div className="flex items-center space-x-2 md:w-auto w-full">
                          <button className="flex-1 md:flex-none px-4 py-2 border border-rakshaa-border rounded-lg text-sm font-semibold text-rakshaa-navy hover:bg-rakshaa-bg transition-colors">
                            View Details
                          </button>
                        </div>
                      </div>
                    );
                  })}
                </div>
              ) : (
                <div className="bg-rakshaa-bg rounded-lg border border-rakshaa-border p-12 text-center text-rakshaa-muted">
                  <Shield size={32} className="mx-auto mb-3 opacity-50" />
                  <p className="font-semibold text-rakshaa-navy mb-1">No Emergencies</p>
                  <p className="text-sm">This user has not triggered any SOS alerts.</p>
                </div>
              )}
            </div>
          </motion.div>
        )}

        {/* Other Tabs Content */}
        {activeTab !== 'Overview' && activeTab !== 'Emergency Contacts' && activeTab !== 'Emergency History' && (
          <motion.div 
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            className="bg-white border border-rakshaa-border rounded-xl p-12 text-center shadow-sm"
          >
            <div className="w-16 h-16 bg-rakshaa-bg rounded-full flex items-center justify-center mx-auto mb-4 text-rakshaa-muted">
              <FileText size={32} />
            </div>
            <h3 className="text-xl font-bold text-rakshaa-navy mb-2">{activeTab}</h3>
            <p className="text-rakshaa-muted max-w-md mx-auto">This section contains detailed {activeTab.toLowerCase()} data for {user.fullName || 'Unknown'}. Detailed records will populate here.</p>
          </motion.div>
        )}

      </div>
    </motion.div>
  );
}

function Tab({ children, active, onClick }: any) {
  return (
    <button 
      onClick={onClick}
      className={`py-4 px-1 whitespace-nowrap text-sm font-semibold border-b-2 transition-colors ${active ? 'border-rakshaa-coral text-rakshaa-coral' : 'border-transparent text-rakshaa-muted hover:text-rakshaa-navy'}`}
    >
      {children}
    </button>
  );
}

function StatCard({ icon, bg, title, value, subtitle, trend, trendColor = "text-rakshaa-muted" }: any) {
  return (
    <div className="bg-white p-5 rounded-xl border border-rakshaa-border shadow-sm flex items-start space-x-4">
      <div className={`w-12 h-12 rounded-full flex items-center justify-center shrink-0 ${bg}`}>
        {icon}
      </div>
      <div className="flex-1">
        <p className="text-xs font-semibold text-rakshaa-navy mb-1">{title}</p>
        <p className="text-2xl font-bold text-rakshaa-navy">{value}</p>
        <div className="flex items-center justify-between mt-1">
          <p className="text-xs text-rakshaa-muted">{subtitle}</p>
          <span className={`text-xs font-bold ${trendColor}`}>{trend}</span>
        </div>
      </div>
    </div>
  );
}

function ActivityItem({ icon, bg, title, date }: any) {
  return (
    <div className="relative pl-6 pb-2">
      <div className={`absolute -left-[14px] top-0.5 w-7 h-7 rounded-full border-2 border-white flex items-center justify-center ${bg}`}>
        {icon}
      </div>
      <div>
        <p className="text-sm font-semibold text-rakshaa-navy">{title}</p>
        <p className="text-xs text-rakshaa-muted mt-1">{date}</p>
      </div>
    </div>
  );
}
