<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Fasilitas extends Model
{
    protected $table = 'fasilitas';
    protected $primaryKey = 'id_fasilitas';

    protected $fillable = [
        'nama_fasilitas'
    ];

    public function kamar()
    {
        return $this->belongsToMany(Kamar::class, 'fasilitas_kamar', 'id_fasilitas', 'id_kamar');
    }
}