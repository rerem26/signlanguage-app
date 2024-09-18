import random
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score
import joblib

# English and Filipino words
english_words = [
    "HELLO", "WORLD", "SIGN", "LANGUAGE", "PLEASE", "THANK YOU", "SORRY", "YES", "NO",
    "GOOD MORNING", "GOOD NIGHT", "HELP", "FAMILY", "FRIEND", "LOVE", "HAPPY", "SAD",
    "EAT", "DRINK", "WATER", "FOOD", "HOUSE", "SCHOOL", "WORK", "PLAY", "STOP", "GO",
    "COME", "WAIT", "BATHROOM", "SLEEP", "BOOK", "PEN", "COMPUTER", "PHONE", "MONEY",
    "SHOP", "STORE", "COLD", "HOT", "RAIN", "SUN", "WIND", "SNOW", "FIRE", "TREE",
    "FLOWER", "DOG", "CAT", "BIRD", "FISH", "CAR", "BIKE", "BUS", "TRAIN", "AIRPLANE",
    "FATHER", "MOTHER", "BROTHER", "SISTER", "BABY", "CHILD", "MAN", "WOMAN", "DOCTOR",
    "NURSE", "TEACHER", "POLICE", "FIREMAN", "LAWYER", "PAINTER", "DANCER", "SINGER",
    "MUSIC", "MOVIE", "DREAM", "READ", "WRITE", "TALK", "HEAR", "SEE", "SMELL", "TASTE",
    "TOUCH", "RUN", "WALK", "JUMP", "DANCE", "SIT", "STAND", "OPEN", "CLOSE", "INSIDE",
    "OUTSIDE", "LEFT", "RIGHT", "UP", "DOWN", "FAST", "SLOW", "BIG", "SMALL", "HUNGRY",
    "THIRSTY", "TIRED", "BEAUTIFUL", "UGLY", "ANGRY", "LAUGH", "CRY", "SING", "PLAY",
    "READ", "WRITE", "COUNT", "DRAW", "BUILD", "SWIM", "DRIVE", "FLY", "WALK", "RUN",
    "CLIMB", "FIGHT", "KISS", "HUG", "SHAKE HANDS", "WAVE", "POINT", "LISTEN", "THINK",
    "FEEL", "REMEMBER", "FORGET", "DREAM", "IMAGINE", "CREATE", "MAKE", "GIVE", "TAKE",
    "ASK", "ANSWER", "SHOUT", "WHISPER", "TALK", "SPEAK", "SILENT", "NOISE", "LOUD",
    "QUIET", "PEACE", "WAR", "SAFE", "DANGER", "FEAR", "BRAVE", "HERO", "VILLAIN",
    "WIN", "LOSE", "FIGHT", "GUN", "KNIFE", "BOMB", "SWORD", "SHIELD", "BATTLE", "VICTORY",
    "DEFEAT", "HURT", "BLOOD", "PAIN", "HEAL", "CURE", "SICK", "DISEASE", "MEDICINE",
    "DOCTOR", "HOSPITAL", "NURSE", "SURGERY", "BANDAGE", "BURN", "CUT", "INJURY", "BITE",
    "STING", "BREAK", "FIX", "MEND", "REPAIR", "BUILD", "CREATE", "GROW", "PLANT", "SEED",
    "FLOWER", "TREE", "FOREST", "RIVER", "LAKE", "SEA", "OCEAN", "MOUNTAIN", "HILL",
    "VALLEY", "DESERT", "JUNGLE", "FIELD", "FARM", "GARDEN", "PARK", "CITY", "TOWN",
    "VILLAGE", "HOUSE"
]

filipino_words = [
    "KAMUSTA", "MUNDO", "WIKA", "PAGSASALITA", "PAKISUYO", "SALAMAT", "PAUMANHIN", "OO", "HINDI",
    "MAGANDANG UMAGA", "MAGANDANG GABI", "TULONG", "PAMILYA", "KAIBIGAN", "PAG-IBIG", "MASAYA",
    "MALUNGKOT", "KAIN", "INOM", "TUBIG", "PAGKAIN", "BAHAY", "ESKWELA", "TRABAHO", "LARO",
    "HINTO", "PUNTA", "HALIKA", "MAGHINTAY", "CR", "TULOG", "LIBRO", "PANGSULAT", "KOMPYUTER",
    "TELEPONO", "PERA", "BILHIN", "TINDIHAN", "MALAMIG", "MAINIT", "ULAN", "ARAW", "HANGIN",
    "NYEBE", "APOY", "PUNO", "BULAKLAK", "ASO", "PUSA", "IBON", "ISDA", "KOTSE", "BIKE", "BUS",
    "TREN", "EROPLANO", "AMA", "INA", "KAPATID", "BUNSO", "BATA", "LALAKI", "BABAE", "DOKTOR",
    "NARS", "GURO", "PULIS", "BOMBERO", "ABOGADO", "PINTOR", "MANANAYAW", "MANG-AAWIT", "MUSIKA",
    "PELIKULA", "PANAGINIP", "BASA", "SULAT", "USAP", "DINGG", "TINGIN", "AMOY", "LASA", "HAWAK",
    "TAKBO", "LAKAD", "TALON", "SAYAW", "UPO", "TAYO", "BUKSAN", "ISARA", "LOOB", "LABAS",
    "KALIWA", "KANAN", "TAAS", "BABA", "MABILIS", "MABAGAL", "MALAKI", "MALIIT", "GUTOM",
    "UHAW", "PAGOD", "MAGANDA", "PANGIT", "GALIT", "TUMAWA", "UMIYAK", "KANTA", "TUGTOG",
    "BASA", "SULAT", "BILANG", "GUHIT", "GUMAWA", "LUMANGOY", "MAGMANEHO", "LUMIPAD",
    "MAGLAKAD", "TUMAKBO", "UMAKYAT", "LUMABAN", "HALIK", "YAKAP", "KAMAY", "KUMAWAY", "ITURO",
    "MAKINIG", "MAG-ISIP", "DAMA", "ALALAHANIN", "KALIMUTAN", "PANAGINIP", "IMAHINASYON",
    "LIKHAIN", "GUMAWA", "MAGBIGAY", "KUNIN", "MAGTANONG", "SAGUTIN", "SIGAW", "BULONG",
    "MAG-USAP", "SALITA", "TAHIMIK", "INGAY", "MALAKAS", "MAHINA", "KAPAYAPAAN", "DIGMAAN",
    "LIGTAS", "DELIKADO", "TAKOT", "MATAPANG", "BAYANI", "KONTRABIDA", "MANALO", "MATALO",
    "LUMABAN", "BARIL", "KUTSILYO", "BOMBA", "ESPADA", "KALASAG", "LABAN", "TAGUMPAY",
    "TALO", "MASAKTAN", "DUGO", "SAKIT", "GUMALING", "LUNAS", "MAYSAKIT", "SAKIT", "GAMOT",
    "DOKTOR", "OSPITAL", "NARS", "OPERASYON", "BANDAHE", "SUNOG", "HIWA", "SAKIT", "KAGAT",
    "TALIM", "BALING", "AYUSIN", "TAYO", "AYUSIN", "GUMAWA", "LUMAGO", "HALAMAN", "BINHI",
    "BULAKLAK", "PUNO", "GUBAT", "ILOG", "DAGAT", "BUNDOK"
]

# Make sure both lists have the same number of words
if len(english_words) != len(filipino_words):
    # Trim the longer list if needed
    if len(english_words) > len(filipino_words):
        english_words = english_words[:len(filipino_words)]
    elif len(filipino_words) > len(english_words):
        filipino_words = filipino_words[:len(english_words)]

# Check if both lists have the same number of elements after adjustment
print(f"Adjusted length of English words: {len(english_words)}")
print(f"Adjusted length of Filipino words: {len(filipino_words)}")

# Shuffle the data
data = list(zip(english_words, filipino_words))
random.shuffle(data)

# Split the data into inputs (English words) and outputs (Filipino words)
english_input = [pair[0] for pair in data]
filipino_output = [pair[1] for pair in data]

# Vectorize the English words using TF-IDF
vectorizer = TfidfVectorizer()
X = vectorizer.fit_transform(english_input)

# Split the data into training and testing sets (80% training, 20% testing)
X_train, X_test, y_train, y_test = train_test_split(X, filipino_output, test_size=0.2, random_state=42)

# Train a logistic regression model
model = LogisticRegression(max_iter=1000)
model.fit(X_train, y_train)

# Test the model and print the accuracy
y_pred = model.predict(X_test)
accuracy = accuracy_score(y_test, y_pred)
print(f"Model Accuracy: {accuracy * 100:.2f}%")

# Save the model and the vectorizer for later use
joblib.dump(model, 'translation_model.pkl')
joblib.dump(vectorizer, 'vectorizer.pkl')

print("Model and vectorizer saved successfully.")
