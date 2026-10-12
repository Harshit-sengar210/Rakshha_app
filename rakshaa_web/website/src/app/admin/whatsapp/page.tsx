"use client";

import { motion } from 'framer-motion';
import { 
  MessageCircle,
  CheckCircle2,
  AlertCircle,
  Clock,
  Search,
  Filter,
  ArrowUpRight,
  X,
  Code
} from 'lucide-react';
import { useState } from 'react';
import { AnimatePresence } from 'framer-motion';

export default function WhatsAppCenterPage() {
  const [selectedMsg, setSelectedMsg] = useState<any>(null);
  return (
    <div className="space-y-6 max-w-7xl mx-auto h-full flex flex-col">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 shrink-0">
        <div>
          <h2 className="text-2xl font-bold text-rakshaa-navy flex items-center">
            WhatsApp Center
          </h2>
          <p className="text-rakshaa-muted mt-1 text-sm">Monitor Rakshaa WhatsApp communication and delivery activity.</p>
        </div>
      </div>

      {/* KPI Cards */}
      <div className="grid grid-cols-2 md:grid-cols-5 gap-4 shrink-0">
        <div className="bg-white p-4 rounded-xl border border-rakshaa-border shadow-sm">
          <p className="text-rakshaa-muted text-xs font-semibold uppercase">Sent</p>
          <p className="text-2xl font-bold text-rakshaa-navy mt-1">12,402</p>
        </div>
        <div className="bg-white p-4 rounded-xl border border-rakshaa-border shadow-sm">
          <p className="text-rakshaa-muted text-xs font-semibold uppercase">Delivered</p>
          <p className="text-2xl font-bold text-rakshaa-navy mt-1">12,180</p>
        </div>
        <div className="bg-white p-4 rounded-xl border border-rakshaa-border shadow-sm">
          <p className="text-rakshaa-muted text-xs font-semibold uppercase">Read</p>
          <p className="text-2xl font-bold text-rakshaa-navy mt-1">9,842</p>
        </div>
        <div className="bg-white p-4 rounded-xl border border-rakshaa-border shadow-sm">
          <p className="text-rakshaa-muted text-xs font-semibold uppercase">Failed</p>
          <p className="text-2xl font-bold text-rakshaa-danger mt-1">12</p>
        </div>
        <div className="bg-white p-4 rounded-xl border border-rakshaa-border shadow-sm bg-rakshaa-success/5">
          <p className="text-rakshaa-success text-xs font-semibold uppercase flex items-center"><ArrowUpRight size={12} className="mr-1"/> Delivery Rate</p>
          <p className="text-2xl font-bold text-rakshaa-success mt-1">98.2%</p>
        </div>
      </div>

      {/* Controls */}
      <div className="flex items-center space-x-3 shrink-0">
        <div className="relative flex-1 max-w-sm">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-rakshaa-muted" size={16} />
          <input 
            type="text" 
            placeholder="Search message ID, recipient..." 
            className="pl-9 pr-4 py-2 w-full border border-rakshaa-border rounded-lg bg-white focus:outline-none focus:ring-2 focus:ring-rakshaa-coral/50 text-sm"
          />
        </div>
        <button className="flex items-center space-x-2 px-3 py-2 bg-white border border-rakshaa-border rounded-lg text-rakshaa-navy font-medium hover:bg-rakshaa-bg transition-colors text-sm">
          <Filter size={16} />
          <span>Type: All</span>
        </button>
        <button className="flex items-center space-x-2 px-3 py-2 bg-white border border-rakshaa-border rounded-lg text-rakshaa-navy font-medium hover:bg-rakshaa-bg transition-colors text-sm">
          <Filter size={16} />
          <span>Status: All</span>
        </button>
      </div>

      {/* Message Table */}
      <div className="bg-white border border-rakshaa-border rounded-xl shadow-sm flex-1 flex flex-col overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="bg-rakshaa-bg border-b border-rakshaa-border">
                <th className="py-3 px-4 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">Time</th>
                <th className="py-3 px-4 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">User</th>
                <th className="py-3 px-4 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">Recipient</th>
                <th className="py-3 px-4 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">Type / Template</th>
                <th className="py-3 px-4 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider w-1/4">Preview</th>
                <th className="py-3 px-4 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">Status</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-rakshaa-border">
              
              <MessageRow 
                time="10:42:05 AM"
                user="Priya Sharma"
                recipient="Rohan Sharma"
                type="Emergency Alert"
                template="emergency_alert_v1"
                preview="🚨 Priya has activated Emergency Mode..."
                status="READ"
                onClick={() => setSelectedMsg({ time: "10:42:05 AM", user: "Priya Sharma", recipient: "Rohan Sharma", type: "Emergency Alert", template: "emergency_alert_v1", preview: "🚨 Priya has activated Emergency Mode...", status: "READ" })}
              />
              
              <MessageRow 
                time="10:42:06 AM"
                user="Ananya Singh"
                recipient="Amit Singh"
                type="Emergency Alert"
                template="emergency_alert_v1"
                preview="🚨 Ananya has activated Emergency Mode..."
                status="DELIVERED"
                onClick={() => setSelectedMsg({ time: "10:42:06 AM", user: "Ananya Singh", recipient: "Amit Singh", type: "Emergency Alert", template: "emergency_alert_v1", preview: "🚨 Ananya has activated Emergency Mode...", status: "DELIVERED" })}
              />

              <MessageRow 
                time="10:35:12 AM"
                user="Karan Patel"
                recipient="Vikram Patel"
                type="Location Update"
                template="location_update_v2"
                preview="📍 Karan's location has been updated..."
                status="READ"
                onClick={() => setSelectedMsg({ time: "10:35:12 AM", user: "Karan Patel", recipient: "Vikram Patel", type: "Location Update", template: "location_update_v2", preview: "📍 Karan's location has been updated...", status: "READ" })}
              />
              
              <MessageRow 
                time="10:15:00 AM"
                user="Rohan Singh"
                recipient="Rohan Singh"
                type="Registration"
                template="otp_verification"
                preview="Your Rakshaa verification code is..."
                status="FAILED"
                onClick={() => setSelectedMsg({ time: "10:15:00 AM", user: "Rohan Singh", recipient: "Rohan Singh", type: "Registration", template: "otp_verification", preview: "Your Rakshaa verification code is...", status: "FAILED" })}
              />

            </tbody>
          </table>
        </div>
      </div>

      {/* Message Modal */}
      <AnimatePresence>
        {selectedMsg && (
          <div className="fixed inset-0 z-50 flex items-center justify-center p-4 sm:p-0">
            <motion.div 
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              onClick={() => setSelectedMsg(null)}
              className="absolute inset-0 bg-rakshaa-navy/40 backdrop-blur-sm"
            />
            <motion.div 
              initial={{ opacity: 0, scale: 0.95, y: 10 }}
              animate={{ opacity: 1, scale: 1, y: 0 }}
              exit={{ opacity: 0, scale: 0.95, y: 10 }}
              className="relative w-full max-w-2xl bg-white rounded-2xl shadow-2xl overflow-hidden flex flex-col max-h-[90vh]"
            >
              {/* Modal Header */}
              <div className="bg-rakshaa-bg p-6 flex justify-between items-start border-b border-rakshaa-border">
                <div>
                  <h3 className="text-xl font-bold text-rakshaa-navy">Message Details</h3>
                  <p className="text-sm text-rakshaa-muted mt-0.5">Template: {selectedMsg.template}</p>
                </div>
                <button 
                  onClick={() => setSelectedMsg(null)}
                  className="p-2 bg-white border border-rakshaa-border text-rakshaa-muted hover:text-rakshaa-navy rounded-full transition-colors"
                >
                  <X size={20} />
                </button>
              </div>

              {/* Modal Body */}
              <div className="p-6 overflow-y-auto scrollbar-hide flex flex-col md:flex-row gap-6">
                
                {/* Meta Data */}
                <div className="flex-1 space-y-6">
                  <div>
                    <h4 className="text-xs font-semibold uppercase text-rakshaa-muted mb-2">Delivery Status</h4>
                    <div className={`inline-flex items-center px-3 py-1.5 rounded-lg text-xs font-bold tracking-wider ${selectedMsg.status === 'READ' ? 'bg-[#34B7F1]/10 text-[#34B7F1]' : selectedMsg.status === 'FAILED' ? 'bg-rakshaa-danger/10 text-rakshaa-danger' : 'bg-rakshaa-success/10 text-rakshaa-success'}`}>
                      {selectedMsg.status === 'FAILED' ? <AlertCircle size={14} className="mr-2" /> : <CheckCircle2 size={14} className="mr-2" />}
                      {selectedMsg.status}
                    </div>
                  </div>

                  <div className="space-y-3 bg-rakshaa-bg p-4 rounded-xl border border-rakshaa-border">
                    <div className="flex justify-between text-sm">
                      <span className="text-rakshaa-muted">Time</span>
                      <span className="font-semibold text-rakshaa-navy">{selectedMsg.time}</span>
                    </div>
                    <div className="flex justify-between text-sm">
                      <span className="text-rakshaa-muted">Triggered By</span>
                      <span className="font-semibold text-rakshaa-navy">{selectedMsg.user}</span>
                    </div>
                    <div className="flex justify-between text-sm">
                      <span className="text-rakshaa-muted">Recipient</span>
                      <span className="font-semibold text-rakshaa-navy">{selectedMsg.recipient}</span>
                    </div>
                    <div className="flex justify-between text-sm">
                      <span className="text-rakshaa-muted">Message Type</span>
                      <span className="font-semibold text-rakshaa-navy">{selectedMsg.type}</span>
                    </div>
                  </div>

                  <div>
                    <button className="text-xs text-blue-500 font-medium flex items-center hover:underline">
                      <Code size={14} className="mr-1" /> View Raw JSON Payload
                    </button>
                  </div>
                </div>

                {/* Simulated WhatsApp Bubble */}
                <div className="flex-1">
                  <h4 className="text-xs font-semibold uppercase text-rakshaa-muted mb-2">Message Preview</h4>
                  <div className="bg-[#EFEAE2] p-4 rounded-xl border border-rakshaa-border min-h-[200px] flex flex-col justify-end relative overflow-hidden">
                    <div className="absolute inset-0 opacity-40 bg-[url('https://static.whatsapp.net/rsrc.php/v3/yl/r/r2_9O7oP_Gk.png')]" />
                    
                    <div className="bg-white p-3 rounded-lg rounded-tl-none shadow-sm relative z-10 max-w-[90%] self-start">
                      <p className="text-[13px] text-gray-800 leading-relaxed whitespace-pre-wrap font-sans">
                        {selectedMsg.preview}
                        {"\n\n"}
                        Tap the link below to track their location live:
                        {"\n"}
                        <span className="text-blue-500 hover:underline cursor-pointer">https://rakshaa.app/t/abc123xyz</span>
                      </p>
                      <div className="text-[10px] text-gray-400 text-right mt-1.5 flex justify-end items-center space-x-1">
                        <span>10:42 AM</span>
                      </div>
                    </div>
                  </div>
                </div>

              </div>
            </motion.div>
          </div>
        )}
      </AnimatePresence>

    </div>
  );
}

function MessageRow({ time, user, recipient, type, template, preview, status, onClick }: any) {
  const isEmergency = type === 'Emergency Alert';
  
  let StatusIcon = CheckCircle2;
  let statusColor = "text-rakshaa-success bg-rakshaa-success/10";
  
  if (status === 'READ') {
    statusColor = "text-[#34B7F1] bg-[#34B7F1]/10"; // WhatsApp Blue tick color
  } else if (status === 'FAILED') {
    StatusIcon = AlertCircle;
    statusColor = "text-rakshaa-danger bg-rakshaa-danger/10";
  } else if (status === 'SENT') {
    StatusIcon = Clock;
    statusColor = "text-rakshaa-muted bg-rakshaa-bg";
  }

  return (
    <tr onClick={onClick} className="hover:bg-rakshaa-bg/50 transition-colors cursor-pointer group">
      <td className="py-3 px-4 text-xs font-mono text-rakshaa-muted">{time}</td>
      <td className="py-3 px-4 text-sm font-medium text-rakshaa-navy">{user}</td>
      <td className="py-3 px-4 text-sm text-rakshaa-navy">{recipient}</td>
      <td className="py-3 px-4">
        <p className={`text-xs font-bold ${isEmergency ? 'text-rakshaa-danger' : 'text-rakshaa-navy'}`}>{type}</p>
        <p className="text-[10px] text-rakshaa-muted font-mono mt-0.5">{template}</p>
      </td>
      <td className="py-3 px-4 text-sm text-rakshaa-muted truncate max-w-xs">{preview}</td>
      <td className="py-3 px-4">
        <div className={`inline-flex items-center px-2 py-0.5 rounded text-[10px] font-bold tracking-wider ${statusColor}`}>
          <StatusIcon size={10} className="mr-1" />
          {status}
        </div>
      </td>
    </tr>
  );
}
