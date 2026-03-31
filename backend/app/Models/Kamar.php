<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Kamar extends Model
{
    protected $table = 'kamar';
    protected $primaryKey = 'id_kamar';

    protected $fillable = [
        'id_hotel',
        'nomor_kamar',
        'tipe_kamar',
        'harga_per_malam',
        'kapasitas',
        'keterangan',
        'status'
    ];

    public function hotel()
    {
        return $this->belongsTo(Hotel::class, 'id_hotel');
    }

    public function foto()
    {
        return $this->hasMany(KamarFoto::class, 'id_kamar');
    }

    public function fasilitas()
    {
        return $this->belongsToMany(Fasilitas::class, 'fasilitas_kamar', 'id_kamar', 'id_fasilitas');
    }

    public function detailBooking()
    {
        return $this->hasMany(DetailBooking::class, 'id_kamar');
    }
}