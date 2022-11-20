<?php

namespace App\Admin\Controllers;

use App\Models\BookType;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Show;
use Encore\Admin\Layout\Content;
use Encore\Admin\Tree;

class BookTypeController extends AdminController
{
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'BookType';

    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    public function index(Content $content){
        $tree = new Tree(new BookType);

        return $content->header('Book Category')->body($tree);
    }
    /**
     * Make a show builder.
     *
     * @param mixed $id
     * @return Show
     */
    protected function detail($id)
    {
        $show = new Show(BookType::findOrFail($id));



        return $show;
    }

    /**
     * Make a form builder.
     *
     * @return Form
     */
    protected function form()
    {
        $form = new Form(new BookType());
        $form->select('parent_id')->options((new BookType())::selectOptions());
        $form->text('title')->required();
        $form->number('order')->default(0);


        return $form;
    }
}
