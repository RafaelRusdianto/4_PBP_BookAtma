<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;
use Laravel\Socialite\Facades\Socialite;

class UserController extends Controller
{
    public function register(Request $request)
    {
        $request->validate([
            'nama' => 'required|string|max:100',
            'email' => 'required|email|unique:user,email',
            'password' => 'required|string|min:6',
            'no_hp' => 'required|string|max:20'
        ]);

        $user = User::create([
            'nama' => $request->nama,
            'email' => $request->email,
            'password' => bcrypt($request->password),
            'no_hp' => $request->no_hp
        ]);

        return response()->json([
            'message' => 'Register berhasil',
            'data' => $user
        ], 201);
    }

    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required'
        ]);

        $user = User::where('email', $request->email)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json([
                'message' => 'Email atau password salah'
            ], 401);
        }

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'message' => 'Login berhasil',
            'user' => $user,
            'token' => $token
        ], 200);
    }

    public function googleLogin(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'nama' => 'required|string|max:100',
            'id_token' => 'required|string'
        ]);

        // Verifikasi ID token dari Google melalui Socialite
        try {
            $googleUser = Socialite::driver('google')->userFromToken($request->id_token);

            // Pastikan email dari Google cocok dengan email yang dikirim
            if ($googleUser->getEmail() !== $request->email) {
                return response()->json([
                    'message' => 'Email tidak valid: token Google tidak sesuai'
                ], 401);
            }
        } catch (\Exception $e) {
            // Log error detail untuk debugging
            logger()->error('Google login verification failed: ' . $e->getMessage());

            return response()->json([
                'message' => 'Token Google tidak valid atau telah kedaluwarsa'
            ], 401);
        }

        $user = User::where('email', $request->email)->first();

        if (!$user) {
            $user = User::create([
                'nama' => $request->nama,
                'email' => $request->email,
                'password' => bcrypt('google_login'),
                'no_hp' => '-'
            ]);
        }

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'message' => 'Login Google berhasil',
            'user' => $user,
            'token' => $token
        ], 200);
    }

    public function profile(Request $request)
    {
        return response()->json([
            'message' => 'Data profile berhasil diambil',
            'data' => $request->user()
        ], 200);
    }

    public function updateProfile(Request $request)
    {
        $user = $request->user();

        $request->validate([
            'nama' => 'sometimes|required|string|max:100',
            'email' => 'sometimes|required|email|unique:user,email,' . $user->id_user . ',id_user',
            'no_hp' => 'sometimes|required|string|max:20',
            'foto_profil' => 'sometimes|image|max:2048',
        ]);

        if ($request->filled('nama')) {
            $user->nama = $request->nama;
        }
        if ($request->filled('email')) {
            $user->email = $request->email;
        }
        if ($request->filled('no_hp')) {
            $user->no_hp = $request->no_hp;
        }

        if ($request->hasFile('foto_profil')) {
            // Hapus foto lama bila ada.
            if ($user->foto_profil) {
                Storage::disk('public')->delete($user->foto_profil);
            }
            $user->foto_profil = $request->file('foto_profil')->store('foto_profil', 'public');
        }

        $user->save();

        return response()->json([
            'message' => 'Profil berhasil diperbarui',
            'data' => $user
        ], 200);
    }

    public function logout(Request $request)
    {
        $request->user()->tokens()->delete();

        return response()->json([
            'message' => 'Logout berhasil'
        ], 200);
    }
}