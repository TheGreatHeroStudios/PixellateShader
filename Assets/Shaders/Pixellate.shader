Shader "Status Effects/Pixellate"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_PixelsPerTile("Pixels Per Tile", Range(1.0, 100.0)) = 10.0
		_Color("Color", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			float _PixelsPerTile;


            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);

                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				//Determine the size of each pixellated tile (in texture coordinates) based on the input 'Pixels Per Tile'
				float2 tileSize = 
					float2
					(
						_PixelsPerTile / _ScreenParams.x,
						_PixelsPerTile / _ScreenParams.y
					);

				//Determine which 'tile' the current pixel falls within and sample the 'top-left' pixel from it to fill the entire tile.
				float2 tileCoordinates = floor(i.uv / tileSize) * tileSize;

                //sample the texture
                fixed4 pixelColor = tex2D(_MainTex, tileCoordinates);

				//apply fog
                UNITY_APPLY_FOG(i.fogCoord, pixelColor);
                
				return pixelColor;
            }
            ENDCG
        }
    }
}
