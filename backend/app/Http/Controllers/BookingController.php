<?php

namespace App\Http\Controllers;

use App\Models\Booking;
use App\Models\DetailBooking;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;

class BookingController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'id_user' => 'required|integer',
            'id_kamar' => 'required|integer',
            'check_in' => 'required|date',
            'check_out' => 'required|date|after_or_equal:check_in',
            'total_harga' => 'required|numeric',
            'harga_per_malam' => 'required|numeric',
        ]);

        $checkIn = Carbon::parse($request->check_in);
        $checkOut = Carbon::parse($request->check_out);
        $jumlahMalam = max(1, $checkIn->diffInDays($checkOut));
        $hargaPerMalam = $request->harga_per_malam;

        $booking = DB::transaction(function () use ($request, $jumlahMalam, $hargaPerMalam) {
            $booking = Booking::create([
                'id_user' => $request->id_user,
                'tgl_booking' => now(),
                'check_in' => $request->check_in,
                'check_out' => $request->check_out,
                'total_harga' => $request->total_harga,
                'status' => 'aktif'
            ]);

            DetailBooking::create([
                'id_booking' => $booking->id_booking,
                'id_kamar' => $request->id_kamar,
                'harga_per_malam' => $hargaPerMalam,
                'jumlah_malam' => $jumlahMalam,
                'subtotal' => $hargaPerMalam * $jumlahMalam,
            ]);

            return $booking;
        });

        $booking->load(['detailBooking.kamar.hotel', 'pembayaran']);

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
        // Aktif = nginap belum selesai (check_out masih di masa depan).
        $today = Carbon::today();

        $booking = Booking::with([
            'detailBooking.kamar.hotel',
            'pembayaran'
        ])
        ->where('id_user', $request->user()->id_user)
        ->whereDate('check_out', '>', $today)
        ->get();

        // Tandai status sesuai aturan tanggal (tidak disimpan, hanya untuk response).
        $booking->each(fn ($b) => $b->status = 'aktif');

        return response()->json([
            'message' => 'Data pesanan aktif berhasil diambil',
            'data' => $booking
        ], 200);
    }

    public function history(Request $request)
    {
        // Selesai = now() sudah mencapai/melewati tanggal check_out.
        $today = Carbon::today();

        $booking = Booking::with([
            'detailBooking.kamar.hotel',
            'pembayaran'
        ])
        ->where('id_user', $request->user()->id_user)
        ->whereDate('check_out', '<=', $today)
        ->get();

        $booking->each(fn ($b) => $b->status = 'selesai');

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