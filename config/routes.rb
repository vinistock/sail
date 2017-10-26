Sail::Engine.routes.draw do
  get 'clusters/new' => 'clusters#new'
  get 'clusters/report' => 'clusters#report'
  get 'clusters/columns' => 'clusters#columns'
end
