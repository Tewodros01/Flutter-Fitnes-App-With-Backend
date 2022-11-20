<?php

namespace App\Admin\Controllers;

use App\Models\Book;
use App\Models\BookType;
use Encore\Admin\Controllers\AdminController;
use Encore\Admin\Form;
use Encore\Admin\Grid;
use Encore\Admin\Show;

class BookController extends AdminController
{
    /**
     * Title for current resource.
     *
     * @var string
     */
    protected $title = 'Book';

    /**
     * Make a grid builder.
     *
     * @return Grid
     */
    protected function grid()
    {
        $grid = new Grid(new Book());
        $grid->book_author();
        $grid->book_title();
        $grid->column('BookType.title','Category');
        $grid->book_description();
        $grid->book_content();
        $grid->column('is_recommend','Recommended')->bool();
        $grid->column('book_thumbnail',_('Thumbnail'))->image('','60','60');


        return $grid;
    }

    /**
     * Make a show builder.
     *
     * @param mixed $id
     * @return Show
     */
    protected function detail($id)
    {
        $show = new Show(Book::findOrFail($id));



        return $show;
    }

    /**
     * Make a form builder.
     *
     * @return Form
     */
    protected function form()
    {
        $form = new Form(new Book());
        $form->select('type_id',_('Category'))->options((new BookType())::selectOptions());
        $form->text('book_author',_('Author'));
        $form->text('book_title',_('Title'));
        $form->text('book_description',_('Description'))->required();
        $form->image('book_thumbnail',_('Thumbnail'));
        $form->file('book_content',_('Books'))->required();
        $state = [
            'on' => ['value' => 1, 'text' => 'Publish'],
            'off' => ['value' => 0, 'text' => 'Draft']
        ];
        $form->switch('is_recommend',_('Publish'))->states($state);


        return $form;
    }
}
