<?php

namespace App\Http\Controllers;

use App\Models\Hotel;
use Illuminate\Http\Request;

class HotelController extends Controller
{
    public function index()
    {
        $hotel = Hotel::with(['foto'])->get();

        return response()->json([
            'message' => 'Data hotel berhasil diambil',
            'data' => $hotel
        ], 200);
    }

    public function show($id)
    {
        $hotel = Hotel::with([
            'kamar.fasilitas',
            'kamar.foto',
            'review'
        ])->find($id);

        if (!$hotel) {
            return response()->json([
                'message' => 'Hotel tidak ditemukan'
            ], 404);
        }

        return response()->json([
            'message' => 'Detail hotel berhasil diambil',
            'data' => $hotel
        ], 200);
    }

    public function search(Request $request)
    {
        $keyword = $request->keyword;

        $hotel = Hotel::with(['foto'])
            ->where('nama_hotel', 'like', '%' . $keyword . '%')
            ->get();

        return response()->json([
            'message' => 'Hasil pencarian hotel',
            'data' => $hotel
        ], 200);
    }
}