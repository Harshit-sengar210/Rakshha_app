"use client";

import { motion } from 'framer-motion';
import { 
  Bell,
  Smartphone,
  MessageCircle,
  PhoneCall,
  Search,
  Filter,
  ArrowDown
} from 'lucide-react';

export default function NotificationsPage() {
  return (
    <div className="space-y-6 max-w-7xl mx-auto h-full flex flex-col">
      {/* Header */}
      <div>
        <h2 className="text-2xl font-bold text-rakshaa-navy">Notification Center</h2>
        <p className="text-rakshaa-muted mt-1 text-sm">Unified monitoring of all alerts sent across Push, SMS, WhatsApp, and Calls.</p>
      </div>

      {/* Funnel Visualization */}
      <div className="bg-white p-6 rounded-xl border border-rakshaa-border shadow-sm shrink-0">
        <h3 className="font-bold text-rakshaa-navy text-sm mb-6 uppercase tracking-wider">Overall Delivery Funnel (24h)</h3>
        
        <div className="flex flex-col md:flex-row items-center justify-between px-10 gap-4">
          
          <div className="flex-1 w-full flex flex-col items-center">
            <motion.div 
              initial={{ height: 0 }}
              animate={{ height: 120 }}
              transition={{ duration: 0.8, ease: "easeOut" }}
              className="w-full bg-rakshaa-navy rounded-t-lg relative flex items-end justify-center pb-4"
            >
              <span className="text-white font-bold text-2xl">8,421</span>
            </motion.div>
            <p className="text-sm font-semibold text-rakshaa-navy mt-4">Messages Sent</p>
          </div>
          
          <ArrowDown className="md:-rotate-90 text-rakshaa-border shrink-0" size={32} />

          <div className="flex-1 w-full flex flex-col items-center">
            <motion.div 
              initial={{ height: 0 }}
              animate={{ height: 100 }}
              transition={{ duration: 0.8, delay: 0.2, ease: "easeOut" }}
              className="w-full bg-rakshaa-success/80 rounded-t-lg relative flex items-end justify-center pb-4"
            >
              <span className="text-white font-bold text-2xl">7,982</span>
            </motion.div>
            <p className="text-sm font-semibold text-rakshaa-navy mt-4">Delivered (94.7%)</p>
          </div>

          <ArrowDown className="md:-rotate-90 text-rakshaa-border shrink-0" size={32} />

          <div className="flex-1 w-full flex flex-col items-center">
            <motion.div 
              initial={{ height: 0 }}
              animate={{ height: 85 }}
              transition={{ duration: 0.8, delay: 0.4, ease: "easeOut" }}
              className="w-full bg-[#34B7F1] rounded-t-lg relative flex items-end justify-center pb-4"
            >
              <span className="text-white font-bold text-2xl">7,104</span>
            </motion.div>
            <p className="text-sm font-semibold text-rakshaa-navy mt-4">Read (89.0%)</p>
          </div>

        </div>
      </div>

      {/* Tabs & Controls */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 shrink-0">
        <div className="flex space-x-1 bg-rakshaa-bg p-1 rounded-lg border border-rakshaa-border overflow-x-auto">
          <TabButton active>All Alerts</TabButton>
          <TabButton icon={Bell}>Push</TabButton>
          <TabButton icon={Smartphone}>SMS</TabButton>
          <TabButton icon={MessageCircle}>WhatsApp</TabButton>
          <TabButton icon={PhoneCall}>Calls</TabButton>
        </div>

        <div className="flex items-center space-x-3">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-rakshaa-muted" size={16} />
            <input 
              type="text" 
              placeholder="Search notifications..." 
              className="pl-9 pr-4 py-1.5 w-64 border border-rakshaa-border rounded-lg bg-white focus:outline-none focus:ring-2 focus:ring-rakshaa-coral/50 text-sm"
            />
          </div>
        </div>
      </div>

      {/* Table */}
      <div className="bg-white border border-rakshaa-border rounded-xl shadow-sm flex-1 flex flex-col overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="bg-rakshaa-bg border-b border-rakshaa-border">
                <th className="py-3 px-4 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">Time</th>
                <th className="py-3 px-4 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">Channel</th>
                <th className="py-3 px-4 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">User</th>
                <th className="py-3 px-4 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">Recipient</th>
                <th className="py-3 px-4 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">Type</th>
                <th className="py-3 px-4 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">Status</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-rakshaa-border">
              
              <NotificationRow 
                time="10:43:12 AM"
                channel="SMS"
                icon={Smartphone}
                user="Priya Sharma"
                recipient="+91 98765 12345"
                type="Emergency Alert"
                status="Delivered"
                statusColor="text-rakshaa-success"
              />
              <NotificationRow 
                time="10:43:12 AM"
                channel="Push"
                icon={Bell}
                user="Priya Sharma"
                recipient="Priya's iPhone"
                type="Safety Timer Warning"
                status="Sent"
                statusColor="text-rakshaa-muted"
              />
              <NotificationRow 
                time="10:42:06 AM"
                channel="WhatsApp"
                icon={MessageCircle}
                user="Ananya Singh"
                recipient="Amit Singh"
                type="Location Update"
                status="Read"
                statusColor="text-[#34B7F1]"
              />
              <NotificationRow 
                time="10:41:00 AM"
                channel="Call"
                icon={PhoneCall}
                user="Karan Patel"
                recipient="+91 98765 12345"
                type="Fake Call Triggered"
                status="Completed"
                statusColor="text-rakshaa-success"
              />

            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}

function TabButton({ children, active, icon: Icon }: any) {
  return (
    <button className={`flex items-center space-x-2 px-4 py-2 rounded-md text-sm font-medium transition-colors whitespace-nowrap ${
      active 
        ? 'bg-white text-rakshaa-navy shadow-sm' 
        : 'text-rakshaa-muted hover:text-rakshaa-navy hover:bg-white/50'
    }`}>
      {Icon && <Icon size={16} />}
      <span>{children}</span>
    </button>
  );
}

function NotificationRow({ time, channel, icon: Icon, user, recipient, type, status, statusColor }: any) {
  return (
    <tr className="hover:bg-rakshaa-bg/50 transition-colors cursor-pointer">
      <td className="py-3 px-4 text-xs font-mono text-rakshaa-muted">{time}</td>
      <td className="py-3 px-4">
        <div className="flex items-center space-x-2 text-sm font-semibold text-rakshaa-navy">
          <Icon size={14} className="text-rakshaa-muted" />
          <span>{channel}</span>
        </div>
      </td>
      <td className="py-3 px-4 text-sm font-medium text-rakshaa-navy">{user}</td>
      <td className="py-3 px-4 text-sm text-rakshaa-navy">{recipient}</td>
      <td className="py-3 px-4 text-sm text-rakshaa-navy">{type}</td>
      <td className="py-3 px-4 text-sm font-bold">
        <span className={statusColor}>{status}</span>
      </td>
    </tr>
  );
}
