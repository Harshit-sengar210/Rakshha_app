"use client";

import { motion } from 'framer-motion';
import { 
  Search,
  Filter,
  History,
  CheckCircle2,
  XCircle,
  AlertTriangle,
  FileText,
  Clock,
  Download,
  MoreVertical,
  ChevronLeft,
  ChevronRight,
  X
} from 'lucide-react';
import Link from 'next/link';
import { useState, useEffect } from 'react';
import { AnimatePresence } from 'framer-motion';
import { collection, query, where, onSnapshot } from 'firebase/firestore';
import { db } from '@/lib/firebase';

export default function EmergencyHistoryPage() {
  const [selectedReport, setSelectedReport] = useState<any>(null);
  const [history, setHistory] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const q = query(
      collection(db, 'emergencies'),
      where('status', '==', 'resolved')
    );
    const unsubscribe = onSnapshot(q, (snapshot) => {
      const histData: any[] = [];
      snapshot.forEach((doc) => histData.push({ id: doc.id, ...doc.data() }));
      histData.sort((a, b) => {
        const timeA = a.resolvedAt?.toMillis ? a.resolvedAt.toMillis() : 0;
        const timeB = b.resolvedAt?.toMillis ? b.resolvedAt.toMillis() : 0;
        return timeB - timeA;
      });
      setHistory(histData);
      setLoading(false);
    });
    return () => unsubscribe();
  }, []);
  return (
    <div className="space-y-6 max-w-7xl mx-auto h-full flex flex-col">
      {/* Header & Controls */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 shrink-0">
        <div>
          <h2 className="text-2xl font-bold text-rakshaa-navy flex items-center">
            <History className="mr-2 text-rakshaa-muted" size={24} />
            Emergency History
          </h2>
          <p className="text-rakshaa-muted mt-1 text-sm">Review past emergency sessions, resolution status, and download reports.</p>
        </div>
        
        <div className="flex flex-wrap items-center gap-3">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-rakshaa-muted" size={16} />
            <input 
              type="text" 
              placeholder="Search by ID, user..." 
              className="pl-9 pr-4 py-2 w-64 border border-rakshaa-border rounded-lg bg-white focus:outline-none focus:ring-2 focus:ring-rakshaa-coral/50 text-sm"
            />
          </div>
          <button className="flex items-center space-x-2 px-3 py-2 bg-white border border-rakshaa-border rounded-lg text-rakshaa-navy font-medium hover:bg-rakshaa-bg transition-colors text-sm">
            <Filter size={16} />
            <span>Date Range</span>
          </button>
          <button className="flex items-center space-x-2 px-3 py-2 bg-white border border-rakshaa-border rounded-lg text-rakshaa-navy font-medium hover:bg-rakshaa-bg transition-colors text-sm">
            <Filter size={16} />
            <span>Status</span>
          </button>
          <button className="flex items-center space-x-2 px-3 py-2 bg-rakshaa-navy text-white rounded-lg font-medium hover:bg-rakshaa-navy/90 transition-colors text-sm ml-auto sm:ml-0">
            <Download size={16} />
            <span>Export</span>
          </button>
        </div>
      </div>

      {/* KPI Stats */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4 shrink-0">
        <div className="bg-white p-4 rounded-xl border border-rakshaa-border shadow-sm">
          <p className="text-rakshaa-muted text-xs font-semibold uppercase">Total Recorded</p>
          <p className="text-2xl font-bold text-rakshaa-navy mt-1">{history.length}</p>
        </div>
      </div>

      {/* Table */}
      <div className="bg-white border border-rakshaa-border rounded-xl shadow-sm flex-1 flex flex-col overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="bg-rakshaa-bg border-b border-rakshaa-border">
                <th className="py-4 px-6 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">Date & Time</th>
                <th className="py-4 px-6 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">Session ID</th>
                <th className="py-4 px-6 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">User</th>
                <th className="py-4 px-6 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">Duration</th>
                <th className="py-4 px-6 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">Trigger Method</th>
                <th className="py-4 px-6 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider">Resolution Status</th>
                <th className="py-4 px-6 text-xs font-semibold text-rakshaa-muted uppercase tracking-wider text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-rakshaa-border">
              {loading ? (
                <tr><td colSpan={7} className="py-8 text-center text-rakshaa-muted">Loading history...</td></tr>
              ) : history.length === 0 ? (
                <tr><td colSpan={7} className="py-8 text-center text-rakshaa-muted">No emergency history found.</td></tr>
              ) : history.map((em) => (
                <HistoryRow key={em.id} data={em} onView={() => setSelectedReport(em)} />
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {/* Report Modal */}
      <AnimatePresence>
        {selectedReport && (
          <div className="fixed inset-0 z-50 flex items-center justify-center p-4 sm:p-0">
            <motion.div 
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              onClick={() => setSelectedReport(null)}
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
                    <h3 className="text-xl font-bold text-rakshaa-navy">Incident Report</h3>
                    <span className="bg-rakshaa-navy/10 text-rakshaa-navy px-2 py-0.5 rounded text-xs font-mono font-bold border border-rakshaa-navy/20">
                      {selectedReport.id}
                    </span>
                  </div>
                  <p className="text-sm text-rakshaa-muted mt-1">Generated automatically upon session termination.</p>
                </div>
                <button 
                  onClick={() => setSelectedReport(null)}
                  className="p-2 bg-white border border-rakshaa-border text-rakshaa-muted hover:text-rakshaa-navy rounded-full transition-colors"
                >
                  <X size={20} />
                </button>
              </div>

              {/* Modal Body */}
              <div className="p-6 overflow-y-auto scrollbar-hide space-y-6">
                
                <div className="grid grid-cols-2 gap-4">
                  <div className="bg-rakshaa-bg p-4 rounded-xl border border-rakshaa-border">
                    <p className="text-xs text-rakshaa-muted uppercase font-semibold">User Involved</p>
                    <p className="text-base font-bold text-rakshaa-navy mt-1">{selectedReport.user}</p>
                  </div>
                  <div className="bg-rakshaa-bg p-4 rounded-xl border border-rakshaa-border">
                    <p className="text-xs text-rakshaa-muted uppercase font-semibold">Time & Duration</p>
                    <p className="text-base font-bold text-rakshaa-navy mt-1">{selectedReport.date}, {selectedReport.time} <span className="text-rakshaa-muted font-normal">({selectedReport.duration})</span></p>
                  </div>
                </div>

                <div>
                  <h4 className="font-bold text-sm text-rakshaa-navy mb-3 border-b border-rakshaa-border pb-2">Session Timeline</h4>
                  <div className="space-y-4">
                    <div className="flex text-sm">
                      <div className="w-16 font-mono text-rakshaa-muted shrink-0">00:00</div>
                      <div className="w-2 bg-rakshaa-coral rounded-full mx-3 shrink-0" />
                      <div>
                        <p className="font-semibold text-rakshaa-navy">Emergency Mode Activated</p>
                        <p className="text-xs text-rakshaa-muted">Triggered via In-App Panic Button</p>
                      </div>
                    </div>
                    <div className="flex text-sm">
                      <div className="w-16 font-mono text-rakshaa-muted shrink-0">00:02</div>
                      <div className="w-2 bg-blue-500 rounded-full mx-3 shrink-0" />
                      <div>
                        <p className="font-semibold text-rakshaa-navy">Safety Network Notified</p>
                        <p className="text-xs text-rakshaa-muted">SMS and WhatsApp dispatched to 3 contacts</p>
                      </div>
                    </div>
                    <div className="flex text-sm">
                      <div className="w-16 font-mono text-rakshaa-muted shrink-0">{selectedReport.duration}</div>
                      <div className="w-2 bg-rakshaa-success rounded-full mx-3 shrink-0" />
                      <div>
                        <p className="font-semibold text-rakshaa-navy">Session Terminated</p>
                        <p className="text-xs text-rakshaa-muted">User confirmed safety with PIN</p>
                      </div>
                    </div>
                  </div>
                </div>

                <div>
                  <h4 className="font-bold text-sm text-rakshaa-navy mb-2 border-b border-rakshaa-border pb-2">Operator Notes</h4>
                  <div className="bg-yellow-50 border border-yellow-200 p-3 rounded-lg text-sm text-yellow-800">
                    User reported feeling unsafe while walking to their car. No physical intervention was required. Marked as safely resolved.
                  </div>
                </div>
              </div>

              {/* Modal Footer */}
              <div className="bg-rakshaa-bg p-4 border-t border-rakshaa-border flex justify-end space-x-3 mt-auto">
                <button 
                  onClick={() => setSelectedReport(null)}
                  className="px-4 py-2 border border-rakshaa-border rounded-lg text-rakshaa-navy font-medium hover:bg-white transition-colors text-sm"
                >
                  Close
                </button>
                <button className="flex items-center px-4 py-2 bg-rakshaa-navy text-white rounded-lg font-medium hover:bg-rakshaa-navy/90 transition-colors text-sm shadow-sm">
                  <Download size={16} className="mr-2" />
                  Download PDF
                </button>
              </div>

            </motion.div>
          </div>
        )}
      </AnimatePresence>

    </div>
  );
}

function HistoryRow({ data, onView }: any) {
  const dateObj = data.resolvedAt?.toDate ? data.resolvedAt.toDate() : new Date();
  const dateStr = dateObj.toLocaleDateString();
  const timeStr = dateObj.toLocaleTimeString();

  return (
    <tr className="hover:bg-rakshaa-bg/50 transition-colors group">
      <td className="py-4 px-6">
        <p className="font-medium text-rakshaa-navy text-sm">{dateStr}</p>
        <p className="text-xs text-rakshaa-muted flex items-center mt-1">
          <Clock size={12} className="mr-1" /> {timeStr}
        </p>
      </td>
      <td className="py-4 px-6">
        <span className="text-xs font-mono text-rakshaa-muted">{data.id}</span>
      </td>
      <td className="py-4 px-6">
        <p className="font-medium text-rakshaa-navy text-sm">{data.userName}</p>
      </td>
      <td className="py-4 px-6 text-sm text-rakshaa-navy font-medium">
        -
      </td>
      <td className="py-4 px-6 text-sm text-rakshaa-muted">
        In-App SOS
      </td>
      <td className="py-4 px-6">
        <span className="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-bold border border-rakshaa-success/20 bg-rakshaa-success/10 text-rakshaa-success uppercase">
          <CheckCircle2 size={12} className="mr-1.5" /> RESOLVED
        </span>
      </td>
      <td className="py-4 px-6 text-right">
        <button 
          onClick={onView}
          className="text-sm font-medium text-rakshaa-coral flex items-center justify-end w-full opacity-0 group-hover:opacity-100 transition-opacity hover:underline"
        >
          <FileText size={14} className="mr-1.5" /> Report
        </button>
      </td>
    </tr>
  );
}
