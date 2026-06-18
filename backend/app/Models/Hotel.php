<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Hotel extends Model
{
    protected $table = 'hotel';
    protected $primaryKey = 'id_hotel';

    protected $fillable = [
        'id_provinsi',
        'nama',
        'alamat',
        'avg_rating',
        'deskripsi'
    ];

    public function provinsi()
    {
        return $this->belongsTo(Provinsi::class, 'id_provinsi');
    }

    public function kamar()
    {
        return $this->hasMany(Kamar::class, 'id_hotel');
    }

    public function foto()
    {
        return $this->hasMany(HotelFoto::class, 'id_hotel');
    }

    public function review()
    {
        return $this->hasMany(Review::class, 'id_hotel');
    }

    // Hitung ulang rata-rata rating dari semua review user pada hotel ini lalu
    // simpan ke kolom avg_rating. Bila belum ada review, simpan 0.
    // Selalu menyimpan nilai terbaru dan mengembalikannya.
    public function recalculateAvgRating(): float
    {
        $avg = (float) $this->review()->avg('rating');
        $avg = round($avg, 1);

        // Hindari query UPDATE bila nilainya tidak berubah.
        if ((float) $this->avg_rating !== $avg) {
            $this->avg_rating = $avg;
            $this->save();
        }

        return $avg;
    }
}