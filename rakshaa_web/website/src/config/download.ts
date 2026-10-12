export interface DownloadConfig {
  isAvailable: boolean;
  version: string;
  releaseDate: string;
  fileSize: string;
  minAndroid: string;
  apkFileName: string;
  apkDownloadUrl: string;
  checksumSha256: string;
  isVerified: boolean;
  instructions: Array<{
    step: string;
    title: string;
    description: string;
  }>;
}

export const downloadConfig: DownloadConfig = {
  isAvailable: true,
  version: "v1.0.4 Release",
  releaseDate: "October 2026",
  fileSize: "59 MB",
  minAndroid: "Android 8.0 (Oreo) or higher",
  apkFileName: "Rakshha.apk",
  apkDownloadUrl: "/downloads/Rakshha.apk",
  checksumSha256: "Verified Official Production Build",
  isVerified: true,
  instructions: [
    {
      step: "01",
      title: "Download the Official Rakshaa APK",
      description: "Tap the download button to save the official package directly to your Android device storage.",
    },
    {
      step: "02",
      title: "Open the Downloaded Package",
      description: "Open the notification tray or your Files/Downloads folder and tap on Rakshha.apk.",
    },
    {
      step: "03",
      title: "Confirm Android Installation Prompt",
      description: "If prompted, allow 'Install unknown apps' for your browser or file manager, then tap Install.",
    },
    {
      step: "04",
      title: "Launch & Grant Essential Permissions",
      description: "Open Rakshaa, sign in with your phone number, and grant Location permission for SOS tracking.",
    },
    {
      step: "05",
      title: "Configure Your Trusted Safety Network",
      description: "Add your emergency contacts and set your Priority contact for instant WhatsApp and call reach.",
    },
  ],
};
