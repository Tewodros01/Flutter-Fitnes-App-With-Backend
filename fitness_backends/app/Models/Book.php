<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Http\Client\Request;

class Book extends Model
{
    use HasFactory;
    
    public function BookType(){
        return $this->hasOne(BookType::class, 'id', 'type_id');
    }
    public function bookUser(){
        return $this->belongsToMany(User::class,'user_books')->withPivot('is_liked')->withTimestamps();
    }
    public function getRecommended(){
        return $this->where(['is_recommend'=>1])->orderBy('id', 'DESC')->limit(3)->get();
    }
    public function getUnRecommended(){
        return $this->where(['is_recommend'=>0])->orderBy('id', 'DESC')->limit(3)->get();
    }
    public function getWelcomeInfo(){
        return $this->where(['type_id'=>3])->orderBy('id', 'DESC')->limit(3)->get();
    }
    public function getRecent(){
        return $this->limit(5)->orderBy('id', 'DESC')->get();
    }
    public function getAllBook(){
        return $this->orderBy('id', 'DESC')->get();
    }
    public function getSearchBook($request){
        return $this->where('book_title','LIKE',"%" .$request->book_title. "%")->get();
    }
    public function getBookByCategory($request){
        return $this->where(['type_id'=>$request->type_id])->orderBy('id', 'DESC')->get();
    }
    public function getLikeBook($user_id){
        return Book::with("bookUser")->whereHas('bookUser',function ($query)use($user_id){
            $query->where('user_id',$user_id);
        })->get();
    }
}
