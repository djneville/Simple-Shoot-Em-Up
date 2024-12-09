from PIL import Image
import matplotlib.pyplot as plt
import math

class ImageColorProcessor:
    def __init__(self, use_webcolors=False, margin=20):
        """
        Initialize the ImageColorProcessor with customization options.
        :param use_webcolors: Whether to use the webcolors library (if available) or hardcoded X11 colors.
        :param margin: Margin of similarity to filter near-duplicate colors.
        """
        self.use_webcolors = use_webcolors
        self.margin = margin
        self.x11_colors = {
            "AliceBlue": (240, 248, 255),
            "AntiqueWhite": (250, 235, 215),
            "Aqua": (0, 255, 255),
            "Aquamarine": (127, 255, 212),
            "Azure": (240, 255, 255),
            "Beige": (245, 245, 220),
            "Black": (0, 0, 0),
            "Blue": (0, 0, 255),
            "Brown": (165, 42, 42),
            "Cyan": (0, 255, 255),
            "DarkBlue": (0, 0, 139),
            "DarkGray": (169, 169, 169),
            "DarkGreen": (0, 100, 0),
            "Gray": (128, 128, 128),
            "Green": (0, 128, 0),
            "LightBlue": (173, 216, 230),
            "LightGray": (211, 211, 211),
            "LightGreen": (144, 238, 144),
            "Magenta": (255, 0, 255),
            "Maroon": (128, 0, 0),
            "Navy": (0, 0, 128),
            "Olive": (128, 128, 0),
            "Orange": (255, 165, 0),
            "Pink": (255, 192, 203),
            "Purple": (128, 0, 128),
            "Red": (255, 0, 0),
            "Silver": (192, 192, 192),
            "Teal": (0, 128, 128),
            "White": (255, 255, 255),
            "Yellow": (255, 255, 0),
        }

    @staticmethod
    def load_image(file_path):
        """
        Load an image file into RGB format.
        :param file_path: Path to the image file.
        :return: Loaded PIL Image in RGB mode.
        """
        return Image.open(file_path).convert("RGB")

    @staticmethod
    def extract_unique_colors(image):
        """
        Extract all unique colors from an image.
        :param image: PIL Image object.
        :return: Sorted list of unique colors.
        """
        return sorted(set(image.getdata()))

    def are_colors_similar(self, color1, color2):
        """
        Check if two colors are similar within the specified margin.
        :param color1: First RGB color tuple.
        :param color2: Second RGB color tuple.
        :return: Boolean indicating similarity.
        """
        return all(abs(c1 - c2) <= self.margin for c1, c2 in zip(color1, color2))

    def filter_similar_colors(self, colors):
        """
        Filter colors by removing near-duplicates based on similarity margin.
        :param colors: List of RGB color tuples.
        :return: Filtered list of unique colors.
        """
        filtered_colors = []
        for color in colors:
            if not any(self.are_colors_similar(color, existing_color) for existing_color in filtered_colors):
                filtered_colors.append(color)
        return filtered_colors

    @staticmethod
    def sort_colors_by_luminance(colors):
        """
        Sort colors by their perceived luminance.
        :param colors: List of RGB color tuples.
        :return: Luminance-sorted list of colors.
        """
        def luminance(color):
            return 0.2126 * color[0] + 0.7152 * color[1] + 0.0722 * color[2]
        return sorted(colors, key=luminance)

    def find_closest_color(self, color):
        """
        Find the closest color from the X11 or webcolors list.
        :param color: RGB color tuple to match.
        :return: Dictionary containing the closest color name and its RGB value.
        """
        if self.use_webcolors:
            try:
                import webcolors
                closest_name = webcolors.rgb_to_name(color)
                return {"name": closest_name, "rgb": color}
            except (ImportError, ValueError):
                pass  # Fallback to hardcoded X11 colors
        closest_match = min(self.x11_colors.items(), key=lambda x: self.color_distance(color, x[1]))
        return {"name": closest_match[0], "rgb": closest_match[1]}

    @staticmethod
    def color_distance(color1, color2):
        """
        Calculate the Euclidean distance between two colors.
        :param color1: First RGB color tuple.
        :param color2: Second RGB color tuple.
        :return: Euclidean distance.
        """
        return math.sqrt(sum((c1 - c2) ** 2 for c1, c2 in zip(color1, color2)))

    def visualize_colors(self, colors, x11_matches=None):
        """
        Visualize colors in a compact swatch without white space.
        :param colors: List of RGB color tuples to display.
        :param x11_matches: List of matched X11 color information.
        """
        swatch_height = 20
        swatch_width = 200
        n_colors = len(colors)

        fig, ax = plt.subplots(figsize=(2, n_colors * 0.2))
        ax.axis("off")

        for i, color in enumerate(colors):
            ax.add_patch(plt.Rectangle((0, -i * swatch_height), swatch_width, swatch_height, color=[c / 255 for c in color]))
            label = f"RGB: {color}"
            if x11_matches:
                x11_info = x11_matches[i]
                label += f" | {x11_info['name']}"
            ax.text(10, -i * swatch_height + swatch_height / 2, label, verticalalignment="center", fontsize=6, color="black")

        ax.set_xlim(0, swatch_width)
        ax.set_ylim(-n_colors * swatch_height, 0)
        plt.subplots_adjust(left=0, right=1, top=1, bottom=0)
        plt.show()

    def process_image(self, file_path):
        """
        Complete image processing pipeline: load image, extract colors, filter, sort, match, and visualize.
        :param file_path: Path to the input image file.
        """
        image = self.load_image(file_path)
        unique_colors = self.extract_unique_colors(image)
        filtered_colors = self.filter_similar_colors(unique_colors)
        sorted_colors = self.sort_colors_by_luminance(filtered_colors)
        x11_matches = [self.find_closest_color(color) for color in sorted_colors]
        self.visualize_colors(sorted_colors, x11_matches)


# Example usage
if __name__ == "__main__":
    processor = ImageColorProcessor(use_webcolors=False, margin=30)  # Customize settings here
    processor.process_image("path_to_your_image.png")  # Replace with your image file path
