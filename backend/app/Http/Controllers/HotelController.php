<?php

namespace App\Http\Controllers;

use App\Models\Hotel;

class HotelController extends Controller
{
    public function index()
    {
        return Hotel::with(['foto'])->get();
    }

    public function show($id)
    {
        return Hotel::with([
            'kamar.fasilitas',
            'kamar.foto',
            'review'
        ])->findOrFail($id);
    }
}