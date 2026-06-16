#!/usr/bin/env bash
# Runs the app in LIVE mode (connected to Supabase) using the keys in
# supabase.json. Usage:  ./run-live.sh   (or: bash run-live.sh -d <device>)
set -e
cd "$(dirname "$0")"

if [ ! -f supabase.json ]; then
  echo "❌ supabase.json not found."
  echo "   Copy the template and fill in your anon key:"
  echo "     cp supabase.example.json supabase.json"
  exit 1
fi

echo "🟢 Running in LIVE mode (Supabase)…"
flutter run --dart-define-from-file=supabase.json "$@"
