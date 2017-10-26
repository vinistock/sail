Sail::Engine.routes.draw do
  get 'clusters/new' => 'clusters#new'
  get 'clusters/report' => 'clusters#report'
end
