<?php

namespace App\Http\Controllers;

use App\Models\UserBook;
use Illuminate\Http\Request;

class UserBookController extends Controller
{
    
    public function geLikeBook(Request $request){
        $list = new UserBook();
        $list = $list->getAllLikeBook($request);
        if (!empty($list)) {
            $liked = $list->is_liked;
            return response()->json([
             'is_liked' => $liked,
             'message' => 'User liked video'
           ]);
        }
         else{
             return response()->json([
                 'is_liked' => 0,
                 'message' => 'User Not liked video'
             ]);
          }
    }
}
