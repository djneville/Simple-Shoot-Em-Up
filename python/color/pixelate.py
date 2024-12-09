from PIL import Image


def pixelate_image(input_file, output_file, pixel_size):
    """
    Pixelate an image by resizing it to a smaller size and then scaling it back up.

    Parameters:
    - input_file: str, path to the input image file.
    - output_file: str, path to save the pixelated image.
    - pixel_size: int, the size of the pixels (higher means more pixelated).
    """
    # Open the image
    image = Image.open(input_file)

    # Calculate the reduced size
    width, height = image.size
    reduced_size = (width // pixel_size, height // pixel_size)

    # Resize the image to the reduced size and scale it back up
    pixelated_image = image.resize(reduced_size, Image.NEAREST)
    pixelated_image = pixelated_image.resize((width, height), Image.NEAREST)

    # Save the pixelated image
    pixelated_image.save(output_file)
    print(f"Pixelated image saved to {output_file}")


if __name__ == "__main__":
    # Example usage
    input_file = "path_to_your_image.png"  # Replace with your input image path
    output_file = "path_to_output_image.png"  # Replace with your output image path
    pixel_size = 16  # Adjust the pixel size for more/less pixelation

    pixelate_image(input_file, output_file, pixel_size)
