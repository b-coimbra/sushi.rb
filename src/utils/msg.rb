require "ffi"

module Win
  extend FFI::Library

  ffi_lib "user32"
  ffi_convention :stdcall

  attach_function :message_box, :MessageBoxA,
                  [ :pointer, :buffer_in, :buffer_in, :int ], :int
end

def msg(args)
  text = args*?\s
  Win.message_box(nil, text, text, 0)
end
