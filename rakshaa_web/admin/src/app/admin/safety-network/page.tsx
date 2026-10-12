"use client";

import { motion } from 'framer-motion';
import { 
  Network,
  Search,
  Filter,
  Users,
  AlertCircle,
  CheckCircle2,
  PhoneCall,
  ShieldAlert,
  ChevronLeft,
  ChevronRight,
  MoreVertical,
  Eye,
  X,
  User
} from 'lucide-react';
import { useState } from 'react';
import { AnimatePresence } from 'framer-motion';

export default function SafetyNetworkPage() {
  const [selectedUserNetwork, setSelectedUserNetwork] = useState<any>(null);
  return (
    <div className="space-y-6 max-w-7xl mx-auto h-full flex flex-col">
      {/* Header & Controls */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 shrink-0">
        <div>
          <h2 className="text-2xl font-bold text-rakshaa-navy flex items-center">
            <Network className="mr-2 text-rakshaa-muted" size={24} />
            Safety Network
          </h2>
          <p className="text-rakshaa-muted mt-1 text-sm">Monitor trusted contact configurations and network health across all users.</p>
        </div>
        
        <div className="flex items-center gap-3">
          <div className="relative hidden sm:block">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-rakshaa-muted" size={16} />
            <input 
              type="text" 
              placeholder="Search users..." 
              className="pl-9 pr-4 py-2 w-64 border border-rakshaa-border rounded-lg bg-white focus:outline-none focus:ring-2 focus:ring-rakshaa-coral/50 text-sm"
            />
          </div>
          <button className="flex items-center space-x-2 px-3 py-2 bg-white border border-rakshaa-border rounded-lg text-rakshaa-navy font-medium hover:bg-rakshaa-bg transition-colors text-sm">
            <Filter size={16} />
            <span>Filter by Health</span>
          </button>
        </div>
      </div>

      {/* KPI Stats */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 shrink-0">
        <div className="bg-white p-5 rounded-xl border border-rakshaa-border shadow-sm flex items-center">
          <div className="w-12 h-12 bg-blue-50 text-blue-500 rounded-full flex items-center justify-center mr-4">
            <Users size={24} />
          </div>
          <div>
            <p className="text-rakshaa-muted text-xs font-semibold uppercase">Total Trusted Contacts</p>
            <p className="text-2xl font-bold text-rakshaa-navy mt-0.5">8,492</p>
          </div>
        </div>
        
        <div className="bg-white p-5 rounded-xl border border-rakshaa-border shadow-sm flex items-center">
          <div className="w-12 h-12 bg-rakshaa-success/10 text-rakshaa-success rounded-full flex items-center justify-center mr-4">
            <CheckCircle2 size={24} />
          </div>
          <div>
            <p className="text-rakshaa-muted text-xs font-semibold uppercase">Avg Contacts / User</p>
            <p className="text-2xl font-bold text-rakshaa-navy mt-0.5">3.2</p>
          </div>
        </div>
        
        <div className="bg-white p-5 rounded-xl border border-rakshaa-border shadow-sm flex items-center">
          <div className="w-12 h-12 bg-rakshaa-warning/10 text-rakshaa-warning rounded-full flex items-center justify-center mr-4">
            <ShieldAlert size={24} />
          </div>
          <div>
            <p className="text-rakshaa-muted text-xs font-semibold uppercase">0 Contacts Added</p>
            <p className="text-2xl font-bold text-rakshaa-warning mt-0.5">241</p>
          </div>
        </div>
        
        <div className="bg-white p-5 rounded-xl border border-rakshaa-border shadow-sm flex items-center">
          <div className="w-12 h-12 bg-rakshaa-coral/10 text-rakshaa-coral rounded-full flex items-center justify-center mr-4">
            <PhoneCall size={24} />
          </div>
          <div>
            <p className="text-rakshaa-muted text-xs font-semibold uppercase">Priority Call Set</p>
            <p className="text-2xl font-bold text-rakshaa-navy mt-0.5">92%</p>
          </div>
        </div>
      </div>

      {/* Network Directory Table */}
      <div className="bg-white border border-rakshaa-border rounded-xl shadow-sm flex-1 flex flex-col overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="bg-rakshaa-bg border-b border-rakshaa-border">
                <th className="py-4 px-6 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">User</th>
                <th className="py-4 px-6 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">Trusted Contacts</th>
                <th className="py-4 px-6 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">Priority Call</th>
                <th className="py-4 px-6 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">Network Health</th>
                <th className="py-4 px-6 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">Last Updated</th>
                <th className="py-4 px-6 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-rakshaa-border">
              
              <NetworkRow 
                name="Priya Sharma"
                userId="RK-USER-1042"
                contacts={4}
                priority="Father"
                health="Excellent"
                lastUpdated="2 days ago"
                onView={() => setSelectedUserNetwork({ name: "Priya Sharma", userId: "RK-USER-1042", contacts: 4, priority: "Father", health: "Excellent" })}
              />
              <NetworkRow 
                name="Rohan Singh"
                userId="RK-USER-1055"
                contacts={0}
                priority="Not Set"
                health="Critical"
                lastUpdated="1 month ago"
                onView={() => setSelectedUserNetwork({ name: "Rohan Singh", userId: "RK-USER-1055", contacts: 0, priority: "Not Set", health: "Critical" })}
              />
              <NetworkRow 
                name="Ananya Desai"
                userId="RK-USER-1061"
                contacts={2}
                priority="Mother"
                health="Good"
                lastUpdated="5 days ago"
                onView={() => setSelectedUserNetwork({ name: "Ananya Desai", userId: "RK-USER-1061", contacts: 2, priority: "Mother", health: "Good" })}
              />
              <NetworkRow 
                name="Kavya Iyer"
                userId="RK-USER-1088"
                contacts={5}
                priority="Husband"
                health="Excellent"
                lastUpdated="12 hours ago"
                onView={() => setSelectedUserNetwork({ name: "Kavya Iyer", userId: "RK-USER-1088", contacts: 5, priority: "Husband", health: "Excellent" })}
              />
              <NetworkRow 
                name="Vikram Patel"
                userId="RK-USER-1102"
                contacts={1}
                priority="Not Set"
                health="Poor"
                lastUpdated="3 weeks ago"
                onView={() => setSelectedUserNetwork({ name: "Vikram Patel", userId: "RK-USER-1102", contacts: 1, priority: "Not Set", health: "Poor" })}
              />

            </tbody>
          </table>
        </div>
        
        {/* Pagination */}
        <div className="mt-auto border-t border-rakshaa-border p-4 flex items-center justify-between bg-rakshaa-bg/50">
          <p className="text-sm text-rakshaa-muted">Showing <span className="font-semibold text-rakshaa-navy">1</span> to <span className="font-semibold text-rakshaa-navy">5</span> of <span className="font-semibold text-rakshaa-navy">2,415</span> users</p>
          <div className="flex items-center space-x-2">
            <button className="p-1 border border-rakshaa-border rounded bg-white text-rakshaa-muted hover:text-rakshaa-navy disabled:opacity-50" disabled>
              <ChevronLeft size={18} />
            </button>
            <button className="px-3 py-1 border border-rakshaa-coral bg-rakshaa-coral/10 text-rakshaa-coral rounded text-sm font-medium">1</button>
            <button className="px-3 py-1 border border-transparent hover:bg-rakshaa-border rounded text-sm text-rakshaa-muted font-medium">2</button>
            <button className="px-3 py-1 border border-transparent hover:bg-rakshaa-border rounded text-sm text-rakshaa-muted font-medium">3</button>
            <span className="text-rakshaa-muted">...</span>
            <button className="p-1 border border-rakshaa-border rounded bg-white text-rakshaa-muted hover:text-rakshaa-navy">
              <ChevronRight size={18} />
            </button>
          </div>
        </div>
      </div>

      {/* View Modal */}
      <AnimatePresence>
        {selectedUserNetwork && (
          <div className="fixed inset-0 z-50 flex items-center justify-center p-4 sm:p-0">
            <motion.div 
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              onClick={() => setSelectedUserNetwork(null)}
              className="absolute inset-0 bg-rakshaa-navy/40 backdrop-blur-sm"
            />
            <motion.div 
              initial={{ opacity: 0, scale: 0.95, y: 10 }}
              animate={{ opacity: 1, scale: 1, y: 0 }}
              exit={{ opacity: 0, scale: 0.95, y: 10 }}
              className="relative w-full max-w-xl bg-white rounded-2xl shadow-2xl overflow-hidden flex flex-col max-h-[90vh]"
            >
              {/* Modal Header */}
              <div className="bg-rakshaa-bg p-6 flex justify-between items-start border-b border-rakshaa-border">
                <div className="flex items-center space-x-4">
                  <div className="w-12 h-12 bg-rakshaa-blush rounded-full flex items-center justify-center border-2 border-white shadow-sm overflow-hidden shrink-0">
                    <div className="w-full h-full bg-rakshaa-navy flex items-center justify-center text-white font-bold text-lg">
                      {selectedUserNetwork.name.split(' ').map((n: string) => n[0]).join('')}
                    </div>
                  </div>
                  <div>
                    <h3 className="text-xl font-bold text-rakshaa-navy">{selectedUserNetwork.name}'s Network</h3>
                    <p className="text-sm text-rakshaa-muted mt-0.5">{selectedUserNetwork.userId}</p>
                  </div>
                </div>
                <button 
                  onClick={() => setSelectedUserNetwork(null)}
                  className="p-2 bg-white border border-rakshaa-border text-rakshaa-muted hover:text-rakshaa-navy rounded-full transition-colors"
                >
                  <X size={20} />
                </button>
              </div>

              {/* Modal Body */}
              <div className="p-6 overflow-y-auto scrollbar-hide space-y-6">
                
                <div className="grid grid-cols-2 gap-4">
                  <div className="bg-rakshaa-bg p-4 rounded-xl border border-rakshaa-border flex items-center justify-between">
                    <div>
                      <p className="text-xs text-rakshaa-muted uppercase font-semibold">Total Contacts</p>
                      <p className="text-xl font-bold text-rakshaa-navy mt-1">{selectedUserNetwork.contacts}</p>
                    </div>
                    <Users size={24} className="text-rakshaa-muted" />
                  </div>
                  <div className="bg-rakshaa-bg p-4 rounded-xl border border-rakshaa-border flex items-center justify-between">
                    <div>
                      <p className="text-xs text-rakshaa-muted uppercase font-semibold">Health Score</p>
                      <p className="text-xl font-bold text-rakshaa-navy mt-1">{selectedUserNetwork.health}</p>
                    </div>
                    <ShieldAlert size={24} className={selectedUserNetwork.health === 'Critical' || selectedUserNetwork.health === 'Poor' ? 'text-rakshaa-coral' : 'text-rakshaa-success'} />
                  </div>
                </div>

                <div>
                  <h4 className="font-bold text-sm text-rakshaa-navy mb-3 border-b border-rakshaa-border pb-2">Trusted Contacts List</h4>
                  
                  {selectedUserNetwork.contacts === 0 ? (
                    <div className="text-center py-6 bg-rakshaa-bg rounded-lg border border-dashed border-rakshaa-border">
                      <AlertCircle size={24} className="mx-auto text-rakshaa-warning mb-2" />
                      <p className="text-sm font-semibold text-rakshaa-navy">No Contacts Added</p>
                      <p className="text-xs text-rakshaa-muted mt-1">This user is highly vulnerable in emergencies.</p>
                    </div>
                  ) : (
                    <div className="space-y-3">
                      {/* Fake List rendering based on contacts count */}
                      {Array.from({ length: selectedUserNetwork.contacts }).map((_, i) => (
                        <div key={i} className="flex items-center justify-between p-3 border border-rakshaa-border rounded-lg bg-white shadow-sm">
                          <div className="flex items-center space-x-3">
                            <div className="w-8 h-8 rounded-full bg-rakshaa-bg flex items-center justify-center">
                              <User size={14} className="text-rakshaa-muted" />
                            </div>
                            <div>
                              <p className="text-sm font-semibold text-rakshaa-navy">
                                {i === 0 && selectedUserNetwork.priority !== 'Not Set' ? selectedUserNetwork.priority : 'Trusted Contact ' + (i+1)}
                              </p>
                              <p className="text-xs text-rakshaa-muted">+91 ••••• ••••</p>
                            </div>
                          </div>
                          <div className="flex items-center space-x-2">
                            {i === 0 && selectedUserNetwork.priority !== 'Not Set' && (
                              <span className="bg-rakshaa-coral/10 text-rakshaa-coral text-[10px] font-bold px-2 py-0.5 rounded uppercase">Priority Call</span>
                            )}
                            <span className="bg-rakshaa-success/10 text-rakshaa-success text-[10px] font-bold px-2 py-0.5 rounded uppercase">Verified</span>
                          </div>
                        </div>
                      ))}
                    </div>
                  )}
                </div>

              </div>

              {/* Modal Footer */}
              <div className="bg-rakshaa-bg p-4 border-t border-rakshaa-border flex justify-end space-x-3 mt-auto">
                <button 
                  onClick={() => setSelectedUserNetwork(null)}
                  className="px-4 py-2 border border-rakshaa-border rounded-lg text-rakshaa-navy font-medium hover:bg-white transition-colors text-sm"
                >
                  Close
                </button>
              </div>

            </motion.div>
          </div>
        )}
      </AnimatePresence>

    </div>
  );
}

function NetworkRow({ name, userId, contacts, priority, health, lastUpdated, onView }: any) {
  let healthColor = "";
  let HealthIcon = CheckCircle2;

  if (health === 'Excellent') {
    healthColor = "bg-rakshaa-success/10 text-rakshaa-success border border-rakshaa-success/20";
    HealthIcon = CheckCircle2;
  } else if (health === 'Good') {
    healthColor = "bg-blue-500/10 text-blue-500 border border-blue-500/20";
    HealthIcon = CheckCircle2;
  } else if (health === 'Poor') {
    healthColor = "bg-rakshaa-warning/10 text-rakshaa-warning border border-rakshaa-warning/20";
    HealthIcon = AlertCircle;
  } else if (health === 'Critical') {
    healthColor = "bg-rakshaa-danger/10 text-rakshaa-danger border border-rakshaa-danger/20";
    HealthIcon = ShieldAlert;
  }

  return (
    <tr className="hover:bg-rakshaa-bg/50 transition-colors group">
      <td className="py-4 px-6">
        <p className="font-semibold text-rakshaa-navy">{name}</p>
        <p className="text-xs text-rakshaa-muted font-mono mt-0.5">{userId}</p>
      </td>
      <td className="py-4 px-6">
        <div className="flex items-center">
          <div className={`flex items-center justify-center w-6 h-6 rounded-full text-xs font-bold ${contacts >= 3 ? 'bg-rakshaa-success/20 text-rakshaa-success' : contacts > 0 ? 'bg-rakshaa-warning/20 text-rakshaa-warning' : 'bg-rakshaa-danger/20 text-rakshaa-danger'}`}>
            {contacts}
          </div>
          <span className="ml-2 text-sm text-rakshaa-muted">contacts</span>
        </div>
      </td>
      <td className="py-4 px-6">
        {priority !== 'Not Set' ? (
          <div className="flex items-center text-sm font-medium text-rakshaa-navy">
            <PhoneCall size={14} className="mr-2 text-rakshaa-coral" />
            {priority}
          </div>
        ) : (
          <span className="text-sm text-rakshaa-muted italic">Not Set</span>
        )}
      </td>
      <td className="py-4 px-6">
        <div className={`inline-flex items-center px-2.5 py-1 rounded-md text-xs font-bold uppercase tracking-wider ${healthColor}`}>
          <HealthIcon size={12} className="mr-1.5" />
          {health}
        </div>
      </td>
      <td className="py-4 px-6 text-sm text-rakshaa-muted">
        {lastUpdated}
      </td>
      <td className="py-4 px-6 text-right">
        <div className="flex items-center justify-end space-x-2">
          <button 
            onClick={onView}
            className="text-blue-500 font-medium text-sm flex items-center hover:bg-blue-50 px-2 py-1 rounded transition-colors"
          >
            <Eye size={14} className="mr-1.5" /> View
          </button>
          <button className="p-1 text-rakshaa-muted hover:bg-rakshaa-border rounded transition-colors opacity-0 group-hover:opacity-100">
            <MoreVertical size={16} />
          </button>
        </div>
      </td>
    </tr>
  );
}
