<?php

namespace App\Http\Controllers;

use App\Models\Book;
use Illuminate\Http\Request;

class BookController extends Controller
{
   
    public function getRecommended(){
        $list = new Book();
        $list = $list->getRecommended();
        foreach($list as $item){
            $item['book_content']=strip_tags($item['book_content']);
            $item['book_content']=$Content = preg_replace("/&#?[a-z0-9]+;/i"," ",$item['book_content']);
        }
        return response()->json($list);
    }
    public function getAllBook(){
        $list = new Book();
        $list = $list->getAllBook();
        foreach($list as $item){
            $item['book_content']=strip_tags($item['book_content']);
            $item['book_content']=$Content = preg_replace("/&#?[a-z0-9]+;/i"," ",$item['book_content']);
        }
        return response()->json($list);
    }
    public function getBookByCategory(Request $request){
        $list = new Book();
        $list = $list->getBookByCategory($request);
        foreach($list as $item){
            $item['workout_content']=strip_tags($item['workout_content']);
            $item['workout_content']=$Content = preg_replace("/&#?[a-z0-9]+;/i"," ",$item['workout_content']);
        }
        return response()->json($list);
    }
    public function getAllSearchBook(Request $request){
        $list = new Book();
        $list = $list->getSearchBook($request);
        foreach($list as $item){
            $item['book_content']=strip_tags($item['book_content']);
            $item['book_content']=$Content = preg_replace("/&#?[a-z0-9]+;/i"," ",$item['book_content']);
        }
        return response()->json($list);
    }
    public function getAllLikeBook(Request $request){
        $user_id = $request->user_id;
        $list = new Book();
        $list = $list->getLikeBook($user_id);
        foreach($list as $item){
            $item['book_content']=strip_tags($item['book_content']);
            $item['book_content']=$Content = preg_replace("/&#?[a-z0-9]+;/i"," ",$item['book_content']);
        }
        return response()->json($list);
    }
}
