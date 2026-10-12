"use client";

import { motion } from 'framer-motion';
import { 
  Search,
  Filter,
  LifeBuoy,
  MessageSquare,
  AlertCircle,
  MoreVertical,
  X,
  CheckCircle2,
  Clock,
  User
} from 'lucide-react';
import { useState } from 'react';
import { AnimatePresence } from 'framer-motion';

export default function SupportPage() {
  const [selectedTicket, setSelectedTicket] = useState<any>(null);
  return (
    <div className="space-y-6 max-w-7xl mx-auto h-full flex flex-col">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 shrink-0">
        <div>
          <h2 className="text-2xl font-bold text-rakshaa-navy">Support Tickets</h2>
          <p className="text-rakshaa-muted mt-1 text-sm">Manage user inquiries and platform issues.</p>
        </div>
        
        <div className="flex items-center space-x-3">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-rakshaa-muted" size={16} />
            <input 
              type="text" 
              placeholder="Search ticket ID, user..." 
              className="pl-9 pr-4 py-2 w-64 border border-rakshaa-border rounded-lg bg-white focus:outline-none focus:ring-2 focus:ring-rakshaa-coral/50 text-sm"
            />
          </div>
          <button className="flex items-center space-x-2 px-4 py-2 bg-white border border-rakshaa-border rounded-lg text-rakshaa-navy font-medium hover:bg-rakshaa-bg transition-colors text-sm">
            <Filter size={16} />
            <span>Filter</span>
          </button>
        </div>
      </div>

      {/* KPI Cards */}
      <div className="grid grid-cols-3 gap-6 shrink-0">
        <div className="bg-white p-5 rounded-xl border border-rakshaa-border shadow-sm flex items-center space-x-4">
          <div className="w-12 h-12 bg-rakshaa-danger/10 text-rakshaa-danger rounded-full flex items-center justify-center">
            <AlertCircle size={24} />
          </div>
          <div>
            <p className="text-rakshaa-muted text-xs font-semibold uppercase">Open & Unassigned</p>
            <p className="text-2xl font-bold text-rakshaa-navy">12</p>
          </div>
        </div>
        <div className="bg-white p-5 rounded-xl border border-rakshaa-border shadow-sm flex items-center space-x-4">
          <div className="w-12 h-12 bg-rakshaa-warning/10 text-rakshaa-warning rounded-full flex items-center justify-center">
            <LifeBuoy size={24} />
          </div>
          <div>
            <p className="text-rakshaa-muted text-xs font-semibold uppercase">In Progress</p>
            <p className="text-2xl font-bold text-rakshaa-navy">45</p>
          </div>
        </div>
        <div className="bg-white p-5 rounded-xl border border-rakshaa-border shadow-sm flex items-center space-x-4">
          <div className="w-12 h-12 bg-rakshaa-success/10 text-rakshaa-success rounded-full flex items-center justify-center">
            <MessageSquare size={24} />
          </div>
          <div>
            <p className="text-rakshaa-muted text-xs font-semibold uppercase">Resolved (24h)</p>
            <p className="text-2xl font-bold text-rakshaa-navy">128</p>
          </div>
        </div>
      </div>

      {/* Table */}
      <div className="bg-white border border-rakshaa-border rounded-xl shadow-sm flex-1 flex flex-col overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="bg-rakshaa-bg border-b border-rakshaa-border">
                <th className="py-3 px-4 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">Ticket ID</th>
                <th className="py-3 px-4 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">User</th>
                <th className="py-3 px-4 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">Category</th>
                <th className="py-3 px-4 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">Priority</th>
                <th className="py-3 px-4 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">Created</th>
                <th className="py-3 px-4 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">Status</th>
                <th className="py-3 px-4 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">Agent</th>
                <th className="py-3 px-4"></th>
              </tr>
            </thead>
            <tbody className="divide-y divide-rakshaa-border">
              
              <TicketRow 
                id="#TKT-9042"
                user="Priya Sharma"
                category="Emergency"
                priority="High"
                created="10m ago"
                status="Open"
                agent="Unassigned"
                onClick={() => setSelectedTicket({ id: "#TKT-9042", user: "Priya Sharma", category: "Emergency", priority: "High", created: "10m ago", status: "Open", agent: "Unassigned", issue: "The panic button was pressed accidentally in my pocket, but I couldn't find the cancel button fast enough. Please resolve my false alarm record." })}
              />
              <TicketRow 
                id="#TKT-9041"
                user="Rohan Singh"
                category="WhatsApp"
                priority="Medium"
                created="2h ago"
                status="In Progress"
                agent="Amit Patel"
                onClick={() => setSelectedTicket({ id: "#TKT-9041", user: "Rohan Singh", category: "WhatsApp", priority: "Medium", created: "2h ago", status: "In Progress", agent: "Amit Patel", issue: "My WhatsApp emergency contacts are not receiving the test alerts." })}
              />
              <TicketRow 
                id="#TKT-9038"
                user="Ananya Desai"
                category="Account"
                priority="Low"
                created="5h ago"
                status="Resolved"
                agent="Neha Sharma"
                onClick={() => setSelectedTicket({ id: "#TKT-9038", user: "Ananya Desai", category: "Account", priority: "Low", created: "5h ago", status: "Resolved", agent: "Neha Sharma", issue: "I need to change my primary phone number." })}
              />
              <TicketRow 
                id="#TKT-9035"
                user="Karan Patel"
                category="Location"
                priority="High"
                created="1d ago"
                status="Resolved"
                agent="Amit Patel"
                onClick={() => setSelectedTicket({ id: "#TKT-9035", user: "Karan Patel", category: "Location", priority: "High", created: "1d ago", status: "Resolved", agent: "Amit Patel", issue: "The location shared during my safe journey was highly inaccurate." })}
              />

            </tbody>
          </table>
        </div>
      </div>

      {/* Ticket Modal */}
      <AnimatePresence>
        {selectedTicket && (
          <div className="fixed inset-0 z-50 flex items-center justify-center p-4 sm:p-0">
            <motion.div 
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              onClick={() => setSelectedTicket(null)}
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
                  <div className="flex items-center space-x-3">
                    <h3 className="text-xl font-bold text-rakshaa-navy">Support Ticket</h3>
                    <span className="bg-rakshaa-navy/10 text-rakshaa-navy px-2 py-0.5 rounded text-xs font-mono font-bold border border-rakshaa-navy/20">
                      {selectedTicket.id}
                    </span>
                  </div>
                  <p className="text-sm text-rakshaa-muted mt-1">Category: <span className="font-semibold text-rakshaa-navy">{selectedTicket.category}</span></p>
                </div>
                <button 
                  onClick={() => setSelectedTicket(null)}
                  className="p-2 bg-white border border-rakshaa-border text-rakshaa-muted hover:text-rakshaa-navy rounded-full transition-colors"
                >
                  <X size={20} />
                </button>
              </div>

              {/* Modal Body */}
              <div className="p-6 overflow-y-auto scrollbar-hide space-y-6">
                
                <div className="grid grid-cols-3 gap-4">
                  <div className="bg-rakshaa-bg p-4 rounded-xl border border-rakshaa-border">
                    <p className="text-xs text-rakshaa-muted uppercase font-semibold">User</p>
                    <p className="text-base font-bold text-rakshaa-navy mt-1">{selectedTicket.user}</p>
                  </div>
                  <div className="bg-rakshaa-bg p-4 rounded-xl border border-rakshaa-border">
                    <p className="text-xs text-rakshaa-muted uppercase font-semibold">Status</p>
                    <p className={`text-sm font-bold mt-1 ${selectedTicket.status === 'Resolved' ? 'text-rakshaa-success' : selectedTicket.status === 'Open' ? 'text-rakshaa-danger' : 'text-rakshaa-warning'}`}>{selectedTicket.status}</p>
                  </div>
                  <div className="bg-rakshaa-bg p-4 rounded-xl border border-rakshaa-border">
                    <p className="text-xs text-rakshaa-muted uppercase font-semibold">Assigned Agent</p>
                    <p className="text-sm font-bold text-rakshaa-navy mt-1">{selectedTicket.agent}</p>
                  </div>
                </div>

                <div>
                  <h4 className="font-bold text-sm text-rakshaa-navy mb-3 border-b border-rakshaa-border pb-2">User Report</h4>
                  <div className="bg-[#F7F8FA] border border-rakshaa-border p-4 rounded-lg text-sm text-rakshaa-navy whitespace-pre-wrap leading-relaxed shadow-inner">
                    "{selectedTicket.issue}"
                  </div>
                </div>

                <div>
                  <h4 className="font-bold text-sm text-rakshaa-navy mb-3 border-b border-rakshaa-border pb-2">Activity Log</h4>
                  <div className="space-y-4">
                    <div className="flex text-sm">
                      <div className="w-16 font-mono text-rakshaa-muted shrink-0 flex flex-col items-center">
                        <span>{selectedTicket.created}</span>
                        <div className="w-px h-full bg-rakshaa-border mt-1" />
                      </div>
                      <div className="w-6 h-6 rounded-full bg-rakshaa-bg border border-rakshaa-border flex items-center justify-center shrink-0 mx-2 z-10">
                        <User size={12} className="text-rakshaa-muted" />
                      </div>
                      <div className="pb-4">
                        <p className="font-semibold text-rakshaa-navy">Ticket Submitted</p>
                        <p className="text-xs text-rakshaa-muted">By {selectedTicket.user}</p>
                      </div>
                    </div>
                  </div>
                </div>

              </div>

              {/* Modal Footer */}
              <div className="bg-rakshaa-bg p-4 border-t border-rakshaa-border flex justify-between items-center mt-auto">
                <button 
                  onClick={() => setSelectedTicket(null)}
                  className="px-4 py-2 border border-rakshaa-border rounded-lg text-rakshaa-navy font-medium hover:bg-white transition-colors text-sm"
                >
                  Cancel
                </button>
                {selectedTicket.status !== 'Resolved' && (
                  <button 
                    onClick={() => {
                      // Optimistic UI state update simulation
                      setSelectedTicket({...selectedTicket, status: 'Resolved', agent: 'Admin User'});
                    }}
                    className="flex items-center px-6 py-2 bg-rakshaa-success text-white rounded-lg font-bold hover:bg-rakshaa-success/90 transition-colors text-sm shadow-sm"
                  >
                    <CheckCircle2 size={16} className="mr-2" />
                    Solve Issue
                  </button>
                )}
              </div>

            </motion.div>
          </div>
        )}
      </AnimatePresence>

    </div>
  );
}

function TicketRow({ id, user, category, priority, created, status, agent, onClick }: any) {
  let priorityColor = "text-rakshaa-muted bg-rakshaa-bg";
  if (priority === 'High' || priority === 'Critical') priorityColor = "text-rakshaa-danger bg-rakshaa-danger/10";
  if (priority === 'Medium') priorityColor = "text-rakshaa-warning bg-rakshaa-warning/10";

  let statusColor = "text-rakshaa-navy bg-rakshaa-bg border border-rakshaa-border";
  if (status === 'Open') statusColor = "text-white bg-rakshaa-danger border border-rakshaa-danger";
  if (status === 'In Progress') statusColor = "text-rakshaa-warning bg-rakshaa-warning/10 border border-rakshaa-warning/20";
  if (status === 'Resolved') statusColor = "text-rakshaa-success bg-rakshaa-success/10 border border-rakshaa-success/20";

  return (
    <tr onClick={onClick} className="hover:bg-rakshaa-bg/50 transition-colors cursor-pointer group">
      <td className="py-4 px-4 text-xs font-mono font-semibold text-rakshaa-navy">{id}</td>
      <td className="py-4 px-4 text-sm font-medium text-rakshaa-navy">{user}</td>
      <td className="py-4 px-4 text-sm text-rakshaa-navy">{category}</td>
      <td className="py-4 px-4">
        <span className={`px-2 py-0.5 rounded text-xs font-bold uppercase tracking-wider ${priorityColor}`}>{priority}</span>
      </td>
      <td className="py-4 px-4 text-sm text-rakshaa-muted">{created}</td>
      <td className="py-4 px-4">
        <span className={`px-2.5 py-1 rounded-md text-xs font-semibold ${statusColor}`}>{status}</span>
      </td>
      <td className="py-4 px-4 text-sm text-rakshaa-muted">{agent}</td>
      <td className="py-4 px-4 text-right">
        <button className="p-1 text-rakshaa-muted hover:bg-rakshaa-border rounded transition-colors opacity-0 group-hover:opacity-100">
          <MoreVertical size={16} />
        </button>
      </td>
    </tr>
  );
}
