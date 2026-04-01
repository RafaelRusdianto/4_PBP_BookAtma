<?php

namespace App\Http\Controllers;

use App\Models\User;

class UserController extends Controller
{
    public function register(Request $request)
    {
        $user = User::create([
            'nama' => $request->nama,
            'email' => $request->email,
            'password' => bcrypt($request->password),
            'no_hp' => $request->no_hp
        ]);

        return response()->json($user);
    }

    public function login(Request $request)
    {
        $user = User::where('email',$request->email)->first();

        if(!$user || !Hash::check($request->password,$user->password)){
            return response()->json([
                'message' => 'Email atau password salah'
            ],401);
        }

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'user' => $user,
            'token' => $token
        ]);
    }
    
    public function googleLogin(Request $request)
    {
        $request->validate([
            'email' => 'required',
            'nama' => 'required'
        ]);

        $user = User::where('email',$request->email)->first();

        if(!$user){
            $user = User::create([
                'nama'=>$request->nama,
                'email'=>$request->email,
                'password'=>bcrypt('google_login'),
                'no_hp'=>'-'
            ]);
        }

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'user'=>$user,
            'token'=>$token
        ]);
    }

    public function profile(Request $request)
    {
        return $request->user();
    }

    public function logout(Request $request)
    {
        $request->user()->tokens()->delete();

        return response()->json([
            'message' => 'Logout berhasil'
        ]);
    }
}