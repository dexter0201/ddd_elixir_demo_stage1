module SysOps exposing (Model, Msg(..), initModel, update, view)

import Html exposing (..)
import Html.Attributes exposing (class, id, placeholder, style, type_, value)
import Html.Events exposing (onClick, onInput)
import Date.Format


-- Local Imports

import Shipping
import HandlingEvent as HE
import Styles exposing (..)


type alias Model =
    { shippingModel : Shipping.Model
    , searchCriteria : String
    }


initModel : Model
initModel =
    Model Shipping.initModel ""


type Msg
    = SearchHandlingEvents
    | ShippingMsg Shipping.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SearchHandlingEvents ->
            let
                ( newShippingModel, cmd ) =
                    Shipping.update (Shipping.FindHandlingEvents) model.newShippingModel
            in
                ( { model | shippingModel = newShippingModel }, Cmd.map ShippingMsg cmd )

        ShippingMsg shippingMsg ->
            let
                ( newShippingModel, newCmd ) =
                    Shipping.update shippingMsg model.shippingModel
            in
                ( { model | shippingModel = newShippingModel }, Cmd.map ShippingMsg newCmd )


view : Model -> Html Msg
view model =
    div []
        [ viewHeader
        , viewMessage model
        , viewSearchLine model
        , viewDetail model.shippingModel
        ]


viewHeader : Html Msg
viewHeader =
    div [ class row ]
        [ div [ class (colS3 "") ] [ p [] [] ]
        , div [ class (colS6 "w3-center") ]
            [ div []
                [ h1
                    [ class ""
                    , style [ ( "font", "bold" ), ( "color", "MidnightBlue" ) ]
                    ]
                    [ text "Systems Operation Manager" ]
                ]
            ]
        ]


viewMessage : Model -> Html Msg
viewMessage model =
    case model.message of
        Just message ->
            div []
                [ div [ class row ]
                    [ div [ class (colS3 "") ] [ p [] [] ]
                    , div [ class (colS6 "w3-center") ]
                        [ h3 [] [ span [ class "w3-pale-red" ] [ text message ] ] ]
                    ]
                , div [] [ p [] [] ]
                ]

        Nothing ->
            div [] []


viewSearchLine : Model -> Html Msg
viewSearchLine model =
    div [ class row ]
        [ div [ class colS2 ]
            [ p [] [] ]
        , div [ class (colS8 "w3-center") ]
            [ div [ class "w3-bar" ]
                [ span
                    [ class "w3-bar-item"
                    , style [ ( "color", "MidnightBlue" ) ]
                    ]
                    [ text "Specify Search Criteria: " ]
                , span
                    [ class "w3-bar-item"
                    , style [ ( "font-weight", "bold" ), ( "color", "MidnightBlue" ) ]
                    ]
                    [ text (model.searchCriteria) ]
                , button
                    [ class (buttonClassStr "w3-bar-item w3-margin-left")
                    , onClick SearchHandlingEvents
                    ]
                    [ text "Search! " ]
                ]
            , p [] []
            ]
        ]


viewDetail : Shipping.Model -> Html Msg
viewDetail shippingModel =
    case List.length shippingModel.handlingEvents of
        0 ->
            p [] []

        _ ->
            div []
                [ div [ class row ]
                    [ div [ class colS1 ] [ p [] [] ]
                    , div [ class colS10 ]
                        [ h2 [] [ text "Listing of Handling Events" ] ]
                    , div [ class colS1 ] [ p [] [] ]
                    ]
                , div [ class row ]
                    [ div [ class colS1 ] [ p [] [] ]
                    , div [ class colS10 ] [ viewHandlingEventTable shippingModel.handlingEvents ]
                    , div [ class colS1 ] [ p [] [] ]
                    ]
                , p [] []
                ]


viewHandlingEventTable : List HE.HandlingEvent -> Html Msg
viewHandlingEventTable handlingEventList =
    table [ class "w3-table w3-striped w3-border w3-border-black" ]
        [ thead [ class "w3-pale-yellow" ]
            [ tr []
                [ th [] [ text "Type" ]
                , th [] [ text "Location" ]
                , th [] [ text "Local Comp. Time" ]
                , th [] [ text "Local Reg. Time" ]
                , th [] [ text "Tracking Id" ]
                , th [] [ text "Voyage No" ]
                ]
            ]
        , tbody []
            (List.map viewHandlingEvent handlingEventList)
        ]


viewHandlingEvent : HE.HandlingEvent -> Html Msg
viewHandlingEvent handlingEvent =
    tr []
        [ td [] [ text handlingEvent.event_type ]
        , td [] [ text handlingEvent.location ]
        , td [] [ text (Date.Format.format "%Y-%m-%d %H:%M:%S" handlingEvent.completion_time) ]
        , td [] [ text (Date.Format.format "%Y-%m-%d %H:%M:%S" handlingEvent.registration_time) ]
        , td [] [ text handlingEvent.tracking_id ]
        , td [] [ text handlingEvent.voyage ]
        ]
