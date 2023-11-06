class ProductFormValidator {
  static String? validateName(String value) {
    if (value.isEmpty) {
      return 'Product Name is required';
    }

    if (value.length < 3) {
      return 'Product Name must be at least 3 characters long';
    }

    return null;
  }

  static String? validatePrice(String value) {
    if (value.isEmpty) {
      return 'Price is required';
    }

    if (double.tryParse(value) == null) {
      return 'Price must be a number';
    }

    if (double.parse(value) < 0) {
      return 'Price must be greater than 0';
    }

    return null;
  }

  static String? validateDescription(String value) {
    if (value.isEmpty) {
      return 'Description is required';
    }
    return null;
  }
}
