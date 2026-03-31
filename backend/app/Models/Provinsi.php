<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Provinsi extends Model
{
    protected $table = 'provinsi';
    protected $primaryKey = 'id_provinsi';

    protected $fillable = [
        'nama_provinsi'
    ];

    public function hotel()
    {
        return $this->hasMany(Hotel::class, 'id_provinsi');
    }
}