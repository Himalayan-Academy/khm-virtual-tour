module Page.About exposing (view)

import Html.Styled exposing (..)
import Html.Attributes exposing (class, style)
import Markdown


content =
    """


# An Overview of Kauai's Hindu Monastery

<div class="embed-container"><iframe src="https://www.youtube.com/embed/Yet7_O_gT9k" frameborder="0" allow="accelerometer; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></div>

Kauai Aadheenam, also known as Kauai's Hindu Monastery, is a traditional South-Indian style monastery-temple complex on the tropical Garden Island of Kauai in the Hawaiian chain in the middle of the Pacific Ocean. The head of the monastery, called the Guru Mahasannidhanam, is Satguru Bodhinatha Veylanswami.

This powerful spiritual sanctuary was founded in 1970 by Satguru Sivaya Subramuniyaswami (1927-2001). It is the home of Bodhinatha and his order of swamis, yogis and sadhakas from different nations. The monastery is the headquarters and theological seminary of Saiva Siddhanta Church. It is also home to Himalayan Academy, Hinduism Today magazine and Hindu Heritage Endowment.

Two traditional Saivite Hindu temples are located on the monastery's 363 acres, Kadavul Temple and the San Marga Iraivan Temple, a rare, all-granite Chola-style temple currently being carved in Bangalore, India, and assembled on Kauai. The lush temple grounds are home to granite murtis of Dakshinamurti, Hanuman, Shanmugam, Narmada Lingam, Murugan's Shakti Vel, Ganesha, Nandi, the Guru Parampara and more.

The core of the monastery is the renowned Kadavul Temple in which Lord Siva Nataraja is enshrined. The main puja is held at 9am. Visitors are welcome from 9am to noon every day. Hindu pilgrims have been coming to the temple from around the world for over 40 years to worship and seek audience and darshan with the Guru Mahasannidhanam. For special pilgrimage, please make arrangements in advance.

The monks live a strict lifestyle of daily religious worship, raja yoga sadhanas and service. Morning worship begins in the temple with aratis to Lord Ganesha, Lord Muruga and then Lord Siva, followed by yogic meditation led by the guru. This shared spiritual activity is the anchor for the coming day in which monks serve in one of five areas: temple and kitchen, members and teaching, administration and finance, grounds and maintenance, publications and media.

The monastery's religious tradition is the Nandinatha Sampradaya, which follows the monistic school of Saiva Siddhanta. The lineage is known as the Kailasa Parampara. The philosophy is called Advaita Saiva Siddhanta or Advaita Ishvaravada, known in English as monistic theism or panentheism. Monistic theism simultaneously accepts that God has a personal form, that He creates, pervades and is all that exists and that He ultimately transcends all existence and that the soul is, in essence, one with God.

For more information, read our booklet [All About Kauai's Hindu Monastery](https://www.himalayanacademy.com/monastery/about/intro)

    """

type alias Options =
    { githubFlavored :
          Maybe
              { tables : Bool
              , breaks : Bool
              }
    , defaultHighlighting : Maybe String
    , sanitize : Bool
    , smartypants : Bool
    }

options : Options
options =
    { githubFlavored = Just { tables = True, breaks = False }
    , defaultHighlighting = Nothing
    , sanitize = False
    , smartypants = True
    }

view =
    { title = "About"
    , body =
        [ fromUnstyled <| Markdown.toHtmlWith options [ class "content", style "padding" "50px" ] content
        ]
    } 

