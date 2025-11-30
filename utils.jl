function hfun_bar(vname)
  val = Meta.parse(vname[1])
  return round(sqrt(val), digits=2)
end

function hfun_m1fill(vname)
  var = vname[1]
  return pagevar("index", var)
end

function lx_baz(com, _)
  # keep this first line
  brace_content = Franklin.content(com.braces[1]) # input string
  # do whatever you want here
  return uppercase(brace_content)
end

function hfun_gallery(path)
    html = """
    <div
        x-data="{
        imageGalleryOpened: false,
        imageGalleryActiveUrl: null,
        imageGalleryImageIndex: null,
        imageGallery: ["""

    imgs = readdir("_" * path[1])

    function as_json_ref(img_ref)
        return """
        {
            'photo': '$("/" * path[1] * img_ref)',
            'alt': '$img_ref'
        }
        """
    end

    html *= join(as_json_ref.(imgs), ',')

    html *= raw"""
    ],
        imageGalleryOpen(event) {
            this.imageGalleryImageIndex = event.target.dataset.index;
            this.imageGalleryActiveUrl = event.target.src;
            this.imageGalleryOpened = true;
        },
        imageGalleryClose() {
            this.imageGalleryOpened = false;
            setTimeout(() => this.imageGalleryActiveUrl = null, 300);
        },
        imageGalleryNext(){
            this.imageGalleryImageIndex = (this.imageGalleryImageIndex == this.imageGallery.length) ? 1 : (parseInt(this.imageGalleryImageIndex) + 1);
            this.imageGalleryActiveUrl = this.$refs.gallery.querySelector('[data-index=\'' + this.imageGalleryImageIndex + '\']').src;
        },
        imageGalleryPrev() {
            this.imageGalleryImageIndex = (this.imageGalleryImageIndex == 1) ? this.imageGallery.length : (parseInt(this.imageGalleryImageIndex) - 1);
            this.imageGalleryActiveUrl = this.$refs.gallery.querySelector('[data-index=\'' + this.imageGalleryImageIndex + '\']').src;

        }
    }"
        @image-gallery-next.window="imageGalleryNext()"
        @image-gallery-prev.window="imageGalleryPrev()"
        @keyup.right.window="imageGalleryNext();"
        @keyup.left.window="imageGalleryPrev();"
        class="w-full h-full select-none"
    >
        <div
            class="mx-auto max-w-6xl opacity-0 duration-1000 delay-300 select-none ease animate-fade-in-view"
            style="
                translate: none;
                rotate: none;
                scale: none;
                opacity: 1;
                transform: translate(0px, 0px);
            "
        >
            <ul
                x-ref="gallery"
                id="gallery"
                class="grid grid-cols-2 gap-5 lg:grid-cols-5"
            >
                <template x-for="(image, index) in imageGallery">
                    <li>
                        <img
                            x-on:click="imageGalleryOpen"
                            :src="image.photo"
                            :alt="image.alt"
                            :data-index="index+1"
                            class="object-cover select-none w-full h-auto bg-gray-200 rounded cursor-zoom-in aspect-[5/6] lg:aspect-[2/3] xl:aspect-[3/4]"
                        />
                    </li>
                </template>
            </ul>
        </div>
        <template x-teleport="body">
            <div
                x-show="imageGalleryOpened"
                x-transition:enter="transition ease-in-out duration-300"
                x-transition:enter-start="opacity-0"
                x-transition:leave="transition ease-in-in duration-300"
                x-transition:leave-end="opacity-0"
                @click="imageGalleryClose"
                @keydown.window.escape="imageGalleryClose"
                x-trap.inert.noscroll="imageGalleryOpened"
                class="fixed inset-0 z-[99] flex items-center justify-center bg-black/50 select-none cursor-zoom-out"
                x-cloak
            >
                <div
                    class="flex relative justify-center items-center w-11/12 xl:w-4/5 h-11/12"
                >
                    <div
                        @click="$event.stopPropagation(); $dispatch('image-gallery-prev')"
                        class="flex absolute left-0 justify-center items-center w-14 h-14 text-white rounded-full translate-x-10 cursor-pointer xl:-translate-x-24 2xl:-translate-x-32 bg-white/10 hover:bg-white/20"
                    >
                        <svg
                            class="w-6 h-6"
                            xmlns="http://www.w3.org/2000/svg"
                            fill="none"
                            viewBox="0 0 24 24"
                            stroke-width="1.5"
                            stroke="currentColor"
                        >
                            <path
                                stroke-linecap="round"
                                stroke-linejoin="round"
                                d="M15.75 19.5L8.25 12l7.5-7.5"
                            />
                        </svg>
                    </div>
                    <img
                        x-show="imageGalleryOpened"
                        x-transition:enter="transition ease-in-out duration-300"
                        x-transition:enter-start="opacity-0 transform scale-50"
                        x-transition:leave="transition ease-in-in duration-300"
                        x-transition:leave-end="opacity-0 transform scale-50"
                        class="object-contain object-center w-full h-full select-none cursor-zoom-out"
                        :src="imageGalleryActiveUrl"
                        alt=""
                        style="display: none"
                    />
                    <div
                        @click="$event.stopPropagation(); $dispatch('image-gallery-next');"
                        class="flex absolute right-0 justify-center items-center w-14 h-14 text-white rounded-full -translate-x-10 cursor-pointer xl:translate-x-24 2xl:translate-x-32 bg-white/10 hover:bg-white/20"
                    >
                        <svg
                            class="w-6 h-6"
                            xmlns="http://www.w3.org/2000/svg"
                            fill="none"
                            viewBox="0 0 24 24"
                            stroke-width="1.5"
                            stroke="currentColor"
                        >
                            <path
                                stroke-linecap="round"
                                stroke-linejoin="round"
                                d="M8.25 4.5l7.5 7.5-7.5 7.5"
                            />
                        </svg>
                    </div>
                </div>
            </div>
        </template>
    </div>
"""
    return html
end

function hfun_begin_content()
    return """
    <section class="w-full bg-white pt-7 pb-7 md:pt-20 md:pb-24">
    """
end

function hfun_end_content()
    return """
    </section>
    """
end

function hfun_content_img_left(args)
title = args[1]
content = args[2]
img = args[3]
return """
<div class="box-border flex flex-col items-center content-center px-8 mx-auto leading-6 text-black border-0 border-gray-300 border-solid md:flex-row max-w-7xl lg:px-16">
    <!-- Image -->
    <div class="box-border rounded-sm relative w-full max-w-md px-4 mt-5 mb-4 -ml-5 text-center bg-no-repeat bg-contain border-solid md:ml-0 md:mt-0 md:max-w-none lg:mb-0 md:w-1/2 xl:pl-10">
        <img src="$img" class="p-2 pl-6 pr-5 xl:pl-16 xl:pr-20 " />
    </div>

    <!-- Content -->
    <div class="box-border order-first w-full text-black border-solid md:w-1/2 md:pl-10 md:order-none">
    <h2 class="m-0 text-xl font-semibold leading-tight border-0 border-gray-300 lg:text-3xl md:text-2xl">
                $title
            </h2>
            <p class="pt-4 pb-8 m-0 leading-7 text-gray-700 border-0 border-gray-300 sm:pr-12 xl:pr-32 lg:text-lg">
                $content
            </p>
    </div>
    <!-- End  Content -->
</div>
"""
end

function hfun_content_img_right(args)
    title = args[1]
    content = args[2]
    img = args[3]
    return """
<div class="box-border flex flex-col items-center content-center px-8 mx-auto mt-2 leading-6 text-black border-0 border-gray-300 border-solid md:mt-20 xl:mt-0 md:flex-row max-w-7xl lg:px-16">

    <!-- Content -->
    <div class="box-border w-full text-black border-solid md:w-1/2 md:pl-6 xl:pl-32">
        <h2 class="m-0 text-xl font-semibold leading-tight border-0 border-gray-300 lg:text-3xl md:text-2xl">
            $title
        </h2>
        <p class="pt-4 pb-8 m-0 leading-7 text-gray-700 border-0 border-gray-300 sm:pr-10 lg:text-lg">
            $content
        </p>
    </div>
    <!-- End  Content -->

    <!-- Image -->
    <div class="box-border relative w-full max-w-md px-4 mt-10 mb-4 text-center bg-no-repeat bg-cover border-solid md:mt-0 md:max-w-none lg:mb-0 md:w-1/2">
        <img src="$img" class="pl-4 sm:pr-10 xl:pl-10 lg:pr-32 object-contain" />
    </div>
</div>
"""
end

function hfun_page_title(args)
    title = args[1]
    subtitle = args[2]
    supertitle = args[3]

    return """
    <div class="max-w-7xl mx-auto py-16 px-10 sm:py-24 sm:px-6 lg:px-8 sm:text-center">
           <h2 class="text-base font-semibold text-indigo-600 tracking-wide uppercase">$supertitle</h2>
           <p class="mt-1 text-4xl font-extrabold text-gray-900 sm:text-5xl sm:tracking-tight lg:text-6xl">$title</p>
           <p class="max-w-3xl mt-5 mx-auto text-xl text-gray-500">$subtitle</p>
    </div>
    """
end

function hfun_three_imgs(args)
    return """
    <div class="grid grid-cols-3 gap-4 w-full ml-4">
      <div class="aspect-square">
        <img src="$(args[1])" class="w-full h-full object-cover rounded" />
      </div>

      <div class="aspect-square">
        <img src="$(args[2])" class="w-full h-full object-cover rounded" />
      </div>

      <div class="aspect-square">
        <img src="$(args[3])" class="w-full h-full object-cover rounded" />
      </div>
    </div>
    """
end

function hfun_call_to_action(args)
    return """
    <section class="px-2 py-32 bg-white md:px-0">
      <div class="container items-center max-w-6xl px-8 mx-auto xl:px-5">
        <div class="flex flex-wrap items-center sm:-mx-3">
          <div class="w-full md:w-1/2 md:px-3">
            <div class="w-full pb-6 space-y-6 sm:max-w-md lg:max-w-lg md:space-y-4 lg:space-y-8 xl:space-y-9 sm:pr-5 lg:pr-0 md:pb-0">
              <h1 class="text-4xl font-extrabold tracking-tight text-gray-900 sm:text-5xl md:text-4xl lg:text-5xl xl:text-6xl">
                <span class="block xl:inline">Book a Consultation</span>
              </h1>
              <p class="mx-auto text-base text-gray-500 sm:max-w-md lg:text-xl md:max-w-3xl">It all begins with an idea. Maybe you want to seat all of your loved ones at one table. Maybe you want to add a statement piece to your home or cottage. Or maybe you just have a crazy idea and your looking for someone to bring it to life. Whatever it is, we would love to find a way to make it happen.</p>
              <div class="relative flex flex-col sm:flex-row sm:space-x-4">
                <a href="mailto:info@creativebynature.ca" class="flex items-center w-full px-6 py-3 mb-3 text-lg text-white bg-gray-700 rounded-md sm:mb-0 hover:bg-indigo-700 sm:w-auto" data-primary="indigo-600" data-rounded="rounded-md">
                Email Us
                  <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 ml-1" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-arrow-right"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>
                </a>
                <a href="/contact/" class="flex items-center px-6 py-3 text-gray-500 bg-gray-100 rounded-md hover:bg-gray-200 hover:text-gray-600" data-rounded="rounded-md">
                Contact Info
                </a>
              </div>
            </div>
          </div>
          <div class="w-full md:w-1/2">
            <div class="w-full h-auto overflow-hidden rounded-md shadow-xl sm:rounded-xl" data-rounded="rounded-xl" data-rounded-max="rounded-full">
                <img src="/assets/boards_drying_cta.png">
              </div>
          </div>
        </div>
      </div>
    </section>
    """
end

function hfun_hero_image(args)
    return """
    <div class="relative w-full h-[60vh] flex items-center justify-center">
      <!-- Background image -->
      <img
        src="/assets/gallery/stairs_from_above.webp"
        alt="Hero Image"
        class="absolute inset-0 w-full h-full object-cover"
      />

      <!-- Optional dark overlay -->
      <div class="absolute inset-0 bg-black/40"></div>

      <!-- Centered content -->
      <div class="relative z-10 text-center text-white px-4">
        <h1 class="text-4xl md:text-5xl font-bold mb-4">
        Designed for Life
        </h1>
        <p class="text-lg md:text-xl mb-6">
        Furniture and custom products crafted from locally-sourced wood.
        </p>
        <a
          href="/contact/"
          class="inline-block bg-white text-gray-900 px-6 py-3 rounded-lg font-semibold hover:bg-gray-200 transition"
        >
        Book a Consultation
        </a>
      </div>
    </div>
    """
end
