"use client";

import { motion } from 'framer-motion';
import { 
  Timer,
  Map,
  Shield,
  PhoneCall
} from 'lucide-react';

export default function SafetyToolsPage() {
  return (
    <div className="space-y-6 max-w-7xl mx-auto h-full flex flex-col">
      {/* Header */}
      <div className="shrink-0">
        <h2 className="text-2xl font-bold text-rakshaa-navy">Safety Tools</h2>
        <p className="text-rakshaa-muted mt-1 text-sm">Monitor active non-emergency safety sessions across the platform.</p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 flex-1 overflow-y-auto scrollbar-hide pb-8">
        
        {/* Safety Timer */}
        <div className="bg-white border border-rakshaa-border rounded-xl shadow-sm flex flex-col">
          <div className="p-5 border-b border-rakshaa-border bg-rakshaa-bg/50 flex items-center space-x-3">
            <div className="p-2 bg-rakshaa-navy/10 text-rakshaa-navy rounded-lg">
              <Timer size={20} />
            </div>
            <div>
              <h3 className="font-bold text-rakshaa-navy text-lg">Safety Timer</h3>
              <p className="text-xs text-rakshaa-muted">45 Active Sessions</p>
            </div>
          </div>
          <div className="p-5 flex-1 flex flex-col justify-center items-center">
            <Timer size={48} className="text-rakshaa-muted opacity-20 mb-4" />
            <p className="text-rakshaa-navy font-medium">Monitoring 45 active timers.</p>
            <p className="text-sm text-rakshaa-muted text-center mt-2 max-w-sm">No timers are currently expired or escalated to emergencies.</p>
          </div>
        </div>

        {/* Safe Journey */}
        <div className="bg-white border border-rakshaa-border rounded-xl shadow-sm flex flex-col">
          <div className="p-5 border-b border-rakshaa-border bg-rakshaa-bg/50 flex items-center space-x-3">
            <div className="p-2 bg-rakshaa-coral/10 text-rakshaa-coral rounded-lg">
              <Map size={20} />
            </div>
            <div>
              <h3 className="font-bold text-rakshaa-navy text-lg">Safe Journey</h3>
              <p className="text-xs text-rakshaa-muted">12 Active Journeys</p>
            </div>
          </div>
          <div className="p-5 flex-1 flex flex-col justify-center items-center">
            <Map size={48} className="text-rakshaa-muted opacity-20 mb-4" />
            <p className="text-rakshaa-navy font-medium">Tracking 12 safe journeys.</p>
            <p className="text-sm text-rakshaa-muted text-center mt-2 max-w-sm">Location updates are being routed to authorized trusted contacts.</p>
          </div>
        </div>

        {/* Safety Check */}
        <div className="bg-white border border-rakshaa-border rounded-xl shadow-sm flex flex-col">
          <div className="p-5 border-b border-rakshaa-border bg-rakshaa-bg/50 flex items-center space-x-3">
            <div className="p-2 bg-rakshaa-success/10 text-rakshaa-success rounded-lg">
              <Shield size={20} />
            </div>
            <div>
              <h3 className="font-bold text-rakshaa-navy text-lg">Safety Check</h3>
              <p className="text-xs text-rakshaa-muted">3 Pending Checks</p>
            </div>
          </div>
          <div className="p-5 flex-1 flex flex-col justify-center items-center">
            <Shield size={48} className="text-rakshaa-muted opacity-20 mb-4" />
            <p className="text-rakshaa-navy font-medium">3 users pending check-in.</p>
            <p className="text-sm text-rakshaa-muted text-center mt-2 max-w-sm">Automated reminders have been dispatched.</p>
          </div>
        </div>

        {/* Fake Call */}
        <div className="bg-white border border-rakshaa-border rounded-xl shadow-sm flex flex-col">
          <div className="p-5 border-b border-rakshaa-border bg-rakshaa-bg/50 flex items-center space-x-3">
            <div className="p-2 bg-rakshaa-muted/10 text-rakshaa-navy rounded-lg">
              <PhoneCall size={20} />
            </div>
            <div>
              <h3 className="font-bold text-rakshaa-navy text-lg">Fake Call</h3>
              <p className="text-xs text-rakshaa-muted">Analytics Only</p>
            </div>
          </div>
          <div className="p-5 flex-1 flex flex-col justify-center items-center">
            <PhoneCall size={48} className="text-rakshaa-muted opacity-20 mb-4" />
            <p className="text-rakshaa-navy font-medium">124 Fake Calls triggered today.</p>
            <p className="text-sm text-rakshaa-muted text-center mt-2 max-w-sm">This is an offline feature. Only usage analytics are synced.</p>
          </div>
        </div>

      </div>
    </div>
  );
}
