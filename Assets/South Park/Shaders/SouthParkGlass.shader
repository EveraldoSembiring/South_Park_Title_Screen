// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Effect Test/South Park Glass"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_GlassTex("Glass", 2D) = "white" {}
		_GlassMask("GlasMask", 2D) = "white" {}
		_GlassThreshold("Glass Threshold", Range(0,1)) = 0
		_GlowColor("Glow Color",Color) = (1,0,0,0)
		_GlowThreshold("Glow Threshold", Range(0,1)) = 0
		_GlowRange("Glow Range", Range(0,1)) = 0.1
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			sampler2D _GlassTex;
			sampler2D _GlassMask;
			float4 _GlassMask_TexelSize;
			float _GlassThreshold;
			float _GlowThreshold;
			float _GlowRange;
			float4 _GlowColor;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 noise = tex2D(_GlassTex, i.uv);
				fixed4 col = tex2D(_MainTex, i.uv);
				fixed4 mask = tex2D(_GlassMask, i.uv);

				if (_GlassThreshold > 0 && mask.r <= _GlassThreshold && noise.a > 0)
					col = col + noise;

				if (_GlowThreshold > 0)
				{
					float4 maskGlow = tex2D(_GlassMask, i.uv + float2(-_GlassMask_TexelSize.x * 5, -_GlassMask_TexelSize.y * 5));
					if (maskGlow.r >= _GlowThreshold && maskGlow.r <= _GlowThreshold + _GlowRange)
						col = col + _GlowColor;
				}

				return col ;
			}
			ENDCG
		}
	}
}
