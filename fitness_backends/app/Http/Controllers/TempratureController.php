<?php

namespace App\Http\Controllers;

use App\Models\Temprature;
use Illuminate\Http\Request;

class TempratureController extends Controller
{
    public function getTemprature(){
        $list = new Temprature();
        $list = $list->getTemprature();
        return response()->json($list);
    }
}
