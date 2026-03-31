<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class HotelFoto extends Model
{
    protected $table = 'hotel_foto';
    protected $primaryKey = 'id_hotel_foto';

    protected $fillable = [
        'id_hotel',
        'url_foto'
    ];

    public function hotel()
    {
        return $this->belongsTo(Hotel::class, 'id_hotel');
    }
}