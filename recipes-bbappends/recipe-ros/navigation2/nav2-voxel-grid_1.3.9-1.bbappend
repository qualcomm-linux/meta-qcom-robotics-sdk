# error: declaration of 'invalid_index' shadows a member of 'rclcpp::exceptions::InvalidNodeNameError' [-Werror=shadow]
# error: 'template<class _Codecvt, class _Elem, class _Wide_alloc, class _Byte_alloc> class std::__cxx11::wstring_convert' is deprecated [-Werror=deprecated-declarations]
CXXFLAGS += "-Wno-error=shadow -Wno-error=deprecated-declarations"
