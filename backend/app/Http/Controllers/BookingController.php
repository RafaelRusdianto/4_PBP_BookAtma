<?php

namespace App\Http\Controllers;

use App\Models\Booking;
use App\Models\DetailBooking;
use App\Models\Kamar;
use App\Models\Pembayaran;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class BookingController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'id_user' => 'nullable|integer',
            'id_kamar' => 'required|integer|exists:kamar,id_kamar',
            'check_in' => 'required|date',
            'check_out' => 'required|date|after_or_equal:check_in',
            'harga_per_malam' => 'nullable|numeric|min:0',
            'jumlah_malam' => 'required|integer|min:1',
            'total_harga' => 'nullable|numeric|min:0',
            'metode_pembayaran' => 'nullable|string|max:50',
            'breakfast' => 'nullable|boolean',
            'laundry' => 'nullable|boolean',
            'airport_pickup' => 'nullable|boolean'
        ]);

        $userId = $request->user()?->id_user ?? $request->id_user;

        if (!$userId) {
            return response()->json([
                'message' => 'User booking tidak ditemukan'
            ], 422);
        }

        $booking = DB::transaction(function () use ($request, $userId) {
            $kamar = Kamar::findOrFail($request->id_kamar);
            $hargaPerMalam = $kamar->harga_per_malam;
            $subtotal = $hargaPerMalam * $request->jumlah_malam;
            $addOnTotal = 0;

            if ($request->boolean('breakfast')) {
                $addOnTotal += 150000;
            }

            if ($request->boolean('laundry')) {
                $addOnTotal += 50000;
            }

            if ($request->boolean('airport_pickup')) {
                $addOnTotal += 250000;
            }

            $totalHarga = $subtotal + 269500 + $addOnTotal;

            $booking = Booking::create([
                'id_user' => $userId,
                'tgl_booking' => now(),
                'check_in' => $request->check_in,
                'check_out' => $request->check_out,
                'total_harga' => $totalHarga,
                'status' => $request->filled('metode_pembayaran') ? 'confirmed' : 'pending'
            ]);

            DetailBooking::create([
                'id_kamar' => $request->id_kamar,
                'id_booking' => $booking->id_booking,
                'harga_per_malam' => $hargaPerMalam,
                'jumlah_malam' => $request->jumlah_malam,
                'subtotal' => $subtotal
            ]);

            if ($request->filled('metode_pembayaran')) {
                Pembayaran::create([
                    'id_booking' => $booking->id_booking,
                    'kode_transaksi' => 'TRX-' . strtoupper(Str::random(10)),
                    'metode_pembayaran' => $request->metode_pembayaran,
                    'jumlah_bayar' => $totalHarga,
                    'status_pembayaran' => 'success',
                    'tgl_pembayaran' => now()
                ]);
            }

            return $booking->load([
                'detailBooking.kamar.hotel',
                'pembayaran'
            ]);
        });

        return response()->json([
            'message' => 'Booking berhasil dibuat',
            'data' => $booking
        ], 201);
    }

    public function userBooking($id_user)
    {
        $booking = Booking::with([
            'detailBooking.kamar.hotel',
            'pembayaran'
        ])
        ->where('id_user', $id_user)
        ->get();

        return response()->json([
            'message' => 'Data booking user berhasil diambil',
            'data' => $booking
        ], 200);
    }

    public function index()
    {
        $booking = Booking::with([
            'detailBooking.kamar.hotel',
            'pembayaran'
        ])->get();

        return response()->json([
            'message' => 'Semua data booking berhasil diambil',
            'data' => $booking
        ], 200);
    }

    public function active(Request $request)
    {
        $booking = Booking::with([
            'detailBooking.kamar.hotel',
            'pembayaran'
        ])
        ->where('id_user', $request->user()->id_user)
        ->where('status', '!=', 'selesai')
        ->whereDate('check_out', '>=', now()->toDateString())
        ->get();

        return response()->json([
            'message' => 'Data pesanan aktif berhasil diambil',
            'data' => $booking
        ], 200);
    }

    public function history(Request $request)
    {
        $booking = Booking::with([
            'detailBooking.kamar.hotel',
            'pembayaran'
        ])
        ->where('id_user', $request->user()->id_user)
        ->where(function ($query) {
            $query
                ->where('status', 'selesai')
                ->orWhereDate('check_out', '<', now()->toDateString());
        })
        ->get();

        return response()->json([
            'message' => 'Riwayat pesanan berhasil diambil',
            'data' => $booking
        ], 200);
    }

    public function show($id)
    {
        $booking = Booking::with([
            'detailBooking.kamar.hotel',
            'pembayaran'
        ])->find($id);

        if (!$booking) {
            return response()->json([
                'message' => 'Booking tidak ditemukan'
            ], 404);
        }

        return response()->json([
            'message' => 'Detail booking berhasil diambil',
            'data' => $booking
        ], 200);
    }
}
