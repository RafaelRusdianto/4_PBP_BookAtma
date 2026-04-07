<?php

namespace App\Models;

use Laravel\Sanctum\HasApiTokens;
use Illuminate\Foundation\Auth\User as Authenticatable;

class User extends Authenticatable
{
    use HasApiTokens;

    protected $table = 'user';
    protected $primaryKey = 'id_user';
    public $timestamps = false;

    protected $fillable = [
        'nama',
        'email',
        'password',
        'no_hp',
        'foto_profil'
    ];

    protected $hidden = [
        'password'
    ];

    public function booking()
    {
        return $this->hasMany(Booking::class, 'id_user', 'id_user');
    }
}