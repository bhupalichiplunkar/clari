require 'pagy/extras/metadata'
require 'pagy/extras/overflow'
require 'pagy/extras/headers'

Pagy::DEFAULT[:overflow] = :empty_page
Pagy::DEFAULT[:items] = 10