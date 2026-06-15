<?php

namespace App\Http\Controllers;

use App\Models\Pembayaran;
use App\Models\Booking;
use Illuminate\Http\Request;

class PembayaranController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'id_booking' => 'required|integer|exists:booking,id_booking',
            'metode_pembayaran' => 'required|string|max:50',
            'jumlah_bayar' => 'required|numeric|min:0'
        ]);

        // Generate kode transaksi otomatis jika tidak disediakan
        $kodeTransaksi = $request->input('kode_transaksi', 'TXN-' . $request->id_booking . '-' . now()->format('YmdHis'));

        $pembayaran = Pembayaran::create([
            'id_booking' => $request->id_booking,
            'kode_transaksi' => $kodeTransaksi,
            'metode_pembayaran' => $request->metode_pembayaran,
            'jumlah_bayar' => $request->jumlah_bayar,
            'status_pembayaran' => $request->input('status_pembayaran', 'success'),
            'tgl_pembayaran' => now()
        ]);

        Booking::where('id_booking', $request->id_booking)
            ->update(['status' => 'confirmed']);

        return response()->json([
            'message' => 'Pembayaran berhasil ditambahkan',
            'data' => $pembayaran
        ], 201);
    }

    public function show($id)
    {
        $pembayaran = Pembayaran::with('booking')->find($id);

        if (!$pembayaran) {
            return response()->json([
                'message' => 'Data pembayaran tidak ditemukan'
            ], 404);
        }

        return response()->json([
            'message' => 'Detail pembayaran berhasil diambil',
            'data' => $pembayaran
        ], 200);
    }
}