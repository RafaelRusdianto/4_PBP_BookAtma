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
}