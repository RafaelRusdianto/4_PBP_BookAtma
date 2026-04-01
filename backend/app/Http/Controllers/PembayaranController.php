<?php

namespace App\Http\Controllers;

use App\Models\Pembayaran;

class PembayaranController extends Controller
{
    public function store(Request $request)
    {
        $pembayaran = Pembayaran::create([
            'id_booking' => $request->id_booking,
            'kode_transaksi' => $request->kode_transaksi,
            'metode_pembayaran' => $request->metode_pembayaran,
            'jumlah_bayar' => $request->jumlah_bayar,
            'status_pembayaran' => 'success',
            'tgl_pembayaran' => now()
        ]);

        return response()->json($pembayaran);
    }
}