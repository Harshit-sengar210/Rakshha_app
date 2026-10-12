"use client";

import { motion } from 'framer-motion';
import { 
  Users, 
  AlertTriangle, 
  Radio, 
  BellRing,
  ArrowUpRight,
  ArrowDownRight,
  MapPin,
  Clock,
  CheckCircle2,
  ChevronRight,
  MessageCircle
} from 'lucide-react';

import { useState, useEffect } from 'react';
import { collection, onSnapshot, query, where } from 'firebase/firestore';
import { db } from '@/lib/firebase';

export default function DashboardPage() {
  const [currentDate, setCurrentDate] = useState('');
  
  // Real-time states
  const [totalUsers, setTotalUsers] = useState(0);
  const [totalEmergencies, setTotalEmergencies] = useState(0);
  const [activeEmergencies, setActiveEmergencies] = useState<any[]>([]);
  const [alertsDelivered, setAlertsDelivered] = useState(0);

  useEffect(() => {
    setCurrentDate(new Date().toLocaleDateString('en-US', { weekday: 'long', month: 'long', day: 'numeric' }));

    // Real-time Users
    const unsubUsers = onSnapshot(
      collection(db, 'users'),
      (snapshot) => {
        setTotalUsers(snapshot.size);
      },
      (error) => {
        console.warn('Firestore users listener error:', error.message);
      }
    );

    // Real-time Emergencies
    const unsubEmergencies = onSnapshot(
      collection(db, 'emergencies'),
      (snapshot) => {
        setTotalEmergencies(snapshot.size);
        
        let alerts = 0;
        const active: any[] = [];
        
        snapshot.forEach(doc => {
          const data = doc.data();
          alerts += (data.notifiedCount || 0);
          
          if (data.status === 'active') {
            active.push({ id: doc.id, ...data });
          }
        });
        
        // Sort active by startedAt desc
        active.sort((a, b) => {
          const timeA = a.startedAt?.toMillis ? a.startedAt.toMillis() : 0;
          const timeB = b.startedAt?.toMillis ? b.startedAt.toMillis() : 0;
          return timeB - timeA;
        });
        
        setActiveEmergencies(active);
        setAlertsDelivered(alerts);
      },
      (error) => {
        console.warn('Firestore emergencies listener error:', error.message);
      }
    );

    return () => {
      unsubUsers();
      unsubEmergencies();
    };
  }, []);

  return (
    <div className="space-y-6 max-w-7xl mx-auto">
      {/* Welcome Header */}
      <div>
        <h2 className="text-2xl font-bold text-rakshaa-navy">Good morning, Admin</h2>
        <p className="text-rakshaa-muted mt-1">Here's what's happening across Rakshaa right now. {currentDate && `• ${currentDate}`}</p>
      </div>

      {/* Status Banner */}
      <motion.div 
        initial={{ opacity: 0, y: -20 }}
        animate={{ opacity: 1, y: 0 }}
        className="bg-rakshaa-success/10 border border-rakshaa-success/20 rounded-xl p-4 flex items-center justify-between shadow-sm"
      >
        <div className="flex items-center space-x-4">
          <div className="w-12 h-12 bg-rakshaa-success/20 rounded-full flex items-center justify-center relative">
            <CheckCircle2 className="text-rakshaa-success" size={24} />
          </div>
          <div>
            <h3 className={`font-bold ${activeEmergencies.length > 0 ? 'text-rakshaa-danger' : 'text-rakshaa-success'} text-lg`}>
              {activeEmergencies.length} ACTIVE EMERGENCIES
            </h3>
            <p className="text-rakshaa-navy font-medium">
              {activeEmergencies.length > 0 
                ? 'Immediate attention required! Users are in danger.' 
                : 'All systems are operational and safe.'}
            </p>
          </div>
        </div>
      </motion.div>

      {/* KPI Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <KpiCard 
          title="Total Users" 
          value={totalUsers.toString()} 
          trend="Live" 
          trendUp={true} 
          icon={Users} 
          delay={0.1} 
        />
        <KpiCard 
          title="Total Emergencies" 
          value={totalEmergencies.toString()} 
          trend="Live" 
          trendUp={true} 
          icon={AlertTriangle} 
          delay={0.2} 
        />
        <KpiCard 
          title="Active Right Now" 
          value={activeEmergencies.length.toString()} 
          trend={activeEmergencies.length > 0 ? "ALERT" : "SAFE"} 
          trendUp={activeEmergencies.length > 0 ? false : true} 
          icon={Radio} 
          delay={0.3} 
          highlight={activeEmergencies.length > 0}
        />
        <KpiCard 
          title="Alerts Delivered" 
          value={alertsDelivered.toString()} 
          trend="Live" 
          trendUp={true} 
          icon={BellRing} 
          delay={0.4} 
        />
      </div>

      <div className="grid grid-cols-1 xl:grid-cols-3 gap-6">
        {/* Left Column: Active Emergencies & Map */}
        <div className="xl:col-span-2 space-y-6">
          {/* Active Emergencies List */}
          <div className="bg-white rounded-xl border border-rakshaa-border p-6 shadow-sm">
            <div className="flex items-center justify-between mb-4">
              <h3 className="font-bold text-rakshaa-navy text-lg">Active Emergencies</h3>
              <span className={`px-2.5 py-1 rounded-md text-xs font-bold tracking-wide border ${activeEmergencies.length > 0 ? 'bg-rakshaa-coral/10 text-rakshaa-coral border-rakshaa-coral/20' : 'bg-gray-100 text-gray-500 border-gray-200'}`}>
                {activeEmergencies.length} LIVE
              </span>
            </div>
            
            {activeEmergencies.length === 0 ? (
              <div className="flex flex-col items-center justify-center py-12 text-center bg-[#F7F8FA] rounded-lg border border-dashed border-rakshaa-border">
                <CheckCircle2 size={40} className="text-rakshaa-success/50 mb-3" />
                <p className="text-rakshaa-navy font-semibold text-lg">No active emergencies</p>
                <p className="text-rakshaa-muted text-sm mt-1">All monitored users are currently safe.</p>
              </div>
            ) : (
              <div className="space-y-4">
                {activeEmergencies.slice(0, 3).map((em, idx) => {
                  const timeStr = em.startedAt?.toDate ? em.startedAt.toDate().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }) : 'Unknown time';
                  const locStr = em.latitude ? `Lat: ${em.latitude.toFixed(4)}, Lng: ${em.longitude.toFixed(4)}` : 'Locating...';
                  return (
                    <EmergencyCard 
                      key={em.id}
                      name={em.userName} 
                      time={timeStr} 
                      location={locStr} 
                      contacts={em.notifiedCount || 0} 
                    />
                  );
                })}
              </div>
            )}
          </div>

          {/* Live Map Placeholder */}
          <div className="bg-white rounded-xl border border-rakshaa-border p-6 shadow-sm">
            <h3 className="font-bold text-rakshaa-navy text-lg mb-4">Live Emergency Map</h3>
            <div className="bg-rakshaa-bg rounded-lg h-[400px] border border-rakshaa-border flex items-center justify-center relative overflow-hidden">
              <div className="text-center">
                <MapPin size={48} className="mx-auto text-rakshaa-muted opacity-20 mb-4" />
                <p className="text-rakshaa-muted font-medium">Map Integration Ready</p>
                <p className="text-sm text-rakshaa-muted mt-1">Showing {activeEmergencies.length} active markers</p>
              </div>

            </div>
          </div>
        </div>

        {/* Right Column: Timeline */}
        <div className="bg-white rounded-xl border border-rakshaa-border p-6 shadow-sm">
          <h3 className="font-bold text-rakshaa-navy text-lg mb-6">Recent Emergency Activity</h3>
          
          <div className="flex flex-col items-center justify-center py-16 text-center text-rakshaa-muted">
            <Clock size={32} className="opacity-20 mb-3" />
            <p>No recent activity today.</p>
          </div>
        </div>
      </div>
    </div>
  );
}

// --- Components ---

function KpiCard({ title, value, trend, trendUp, icon: Icon, delay, highlight = false }: any) {
  return (
    <motion.div 
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay }}
      whileHover={{ y: -4, transition: { duration: 0.2 } }}
      className={`bg-white rounded-xl border ${highlight ? 'border-rakshaa-coral/30 ring-1 ring-rakshaa-coral/20' : 'border-rakshaa-border'} p-6 shadow-sm`}
    >
      <div className="flex justify-between items-start">
        <div>
          <p className="text-rakshaa-muted text-sm font-semibold">{title}</p>
          <motion.h4 
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ delay: delay + 0.3, duration: 1 }}
            className={`text-3xl font-bold mt-2 ${highlight ? 'text-rakshaa-coral' : 'text-rakshaa-navy'}`}
          >
            {value}
          </motion.h4>
        </div>
        <div className={`p-2 rounded-lg ${highlight ? 'bg-rakshaa-coral/10 text-rakshaa-coral' : 'bg-rakshaa-bg text-rakshaa-navy'}`}>
          <Icon size={24} />
        </div>
      </div>
      <div className="mt-4 flex items-center">
        {trendUp === true && <ArrowUpRight size={16} className="text-rakshaa-success mr-1" />}
        {trendUp === false && <ArrowDownRight size={16} className="text-rakshaa-danger mr-1" />}
        {trendUp === null && <div className="w-2 h-2 rounded-full bg-rakshaa-coral animate-pulse mr-2" />}
        
        <span className={`text-sm font-semibold ${trendUp === true ? 'text-rakshaa-success' : trendUp === false ? 'text-rakshaa-danger' : 'text-rakshaa-coral'}`}>
          {trend}
        </span>
        {trendUp !== null && <span className="text-sm text-rakshaa-muted ml-2">vs last week</span>}
      </div>
    </motion.div>
  );
}

function EmergencyCard({ name, time, location, contacts }: any) {
  return (
    <div className="border border-rakshaa-coral/20 rounded-xl p-4 bg-white shadow-sm hover:shadow-md transition-shadow flex flex-col sm:flex-row sm:items-center justify-between gap-4">
      <div className="flex items-start space-x-4">
        <div className="mt-1 flex items-center justify-center">
          <div className="w-3 h-3 bg-rakshaa-coral rounded-full animate-pulse" />
        </div>
        <div>
          <div className="flex items-center space-x-3">
            <h4 className="font-bold text-rakshaa-navy text-lg">{name}</h4>
            <span className="text-xs bg-rakshaa-coral/10 text-rakshaa-coral px-2 py-0.5 rounded-full font-bold">ACTIVE</span>
          </div>
          <div className="flex items-center text-rakshaa-muted text-sm mt-1 space-x-4">
            <span className="flex items-center"><Clock size={14} className="mr-1" /> {time}</span>
            <span className="flex items-center"><MapPin size={14} className="mr-1" /> {location}</span>
          </div>
        </div>
      </div>
      
      <div className="flex items-center justify-between sm:justify-end space-x-4 sm:space-x-6 border-t sm:border-t-0 pt-4 sm:pt-0 border-rakshaa-border">
        <div className="text-sm text-rakshaa-navy font-medium">
          <div className="flex items-center text-rakshaa-success mb-1">
            <div className="w-2 h-2 rounded-full bg-rakshaa-success mr-2" />
            Location LIVE
          </div>
          <div className="flex items-center text-rakshaa-muted">
            <Users size={14} className="mr-2" />
            {contacts} contacts notified
          </div>
        </div>
        <button className="bg-rakshaa-bg hover:bg-rakshaa-coral hover:text-white text-rakshaa-navy px-4 py-2 rounded-lg font-medium transition-colors text-sm border border-rakshaa-border hover:border-rakshaa-coral">
          View
        </button>
      </div>
    </div>
  );
}

function TimelineItem({ time, title, description, icon: Icon, color, bg }: any) {
  return (
    <motion.div 
      initial={{ opacity: 0, x: 20 }}
      whileInView={{ opacity: 1, x: 0 }}
      viewport={{ once: true }}
      className="relative pl-8"
    >
      <div className={`absolute -left-[17px] top-1 w-8 h-8 rounded-full border-4 border-white ${bg} ${color} flex items-center justify-center`}>
        <Icon size={14} />
      </div>
      <div>
        <div className="flex items-baseline space-x-2">
          <span className="text-xs font-bold text-rakshaa-muted w-10">{time}</span>
          <h5 className={`font-semibold text-sm ${color === 'text-rakshaa-coral' ? 'text-rakshaa-danger' : 'text-rakshaa-navy'}`}>{title}</h5>
        </div>
        <p className="text-sm text-rakshaa-muted mt-1 ml-12">{description}</p>
      </div>
    </motion.div>
  );
}
