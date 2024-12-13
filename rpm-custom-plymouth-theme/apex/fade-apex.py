from PIL import Image, ImageEnhance
import os

def adjust_lightness(image_path, output_dir, cycles=3, step=1):
    """
    Crée des images avec différents niveaux de luminosité à partir d'une image source.

    :param image_path: Chemin de l'image source (ex. 'target.png').
    :param output_dir: Répertoire où les images générées seront sauvegardées.
    :param cycles: Nombre de cycles (augmentation et diminution).
    :param step: Incrément de la luminosité en pourcentage.
    """
    # Charger l'image source
    image = Image.open(image_path).convert("L")  # Convertir en niveaux de gris

    # Créer le répertoire de sortie s'il n'existe pas
    os.makedirs(output_dir, exist_ok=True)

    image_count = 0

    # Pour chaque cycle, augmenter et réduire la luminosité
    for cycle in range(cycles):
        print(f"Cycle {cycle + 1}/{cycles}")

        # Réduire la luminosité de 100% (blanc) à 0% (noir)
        for lightness in range(100, -1, -step):
            enhancer = ImageEnhance.Brightness(image)
            adjusted_image = enhancer.enhance(lightness / 100)
            output_path = os.path.join(output_dir, f"progress-{image_count}.png")
            adjusted_image.save(output_path)
            image_count += 1

        # Augmenter la luminosité de 0% (noir) à 100% (blanc)
        for lightness in range(0, 101, step):
            enhancer = ImageEnhance.Brightness(image)
            adjusted_image = enhancer.enhance(lightness / 100)
            output_path = os.path.join(output_dir, f"progress-{image_count}.png")
            adjusted_image.save(output_path)
            image_count += 1

    print(f"Images générées et sauvegardées dans le dossier : {output_dir}")

# Paramètres d'exécution
image_path = "target.png"  # Chemin de l'image source
output_dir = "."  # Dossier où les images seront sauvegardées
cycles = 1  # Nombre de cycles (aller-retour)
step = 1  # Incrément de luminosité

# Exécuter la fonction
adjust_lightness(image_path, output_dir, cycles, step)
