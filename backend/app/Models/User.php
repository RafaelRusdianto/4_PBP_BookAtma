<?php

namespace App\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;

class User extends Authenticatable
{
    protected $table = 'user';
    protected $primaryKey = 'id_user';

    protected $fillable = [
        'nama',
        'email',
        'password',
        'no_hp',
        'foto_profil'
    ];

    public function booking()
    {
        return $this->hasMany(Booking::class, 'id_user');
    }
}