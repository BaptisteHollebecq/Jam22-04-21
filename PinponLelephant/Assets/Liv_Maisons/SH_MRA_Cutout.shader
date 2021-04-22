// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "OTHYMF/MRA_Cutout"
{
	Properties
	{
		_AlbedoMap("Albedo Map", 2D) = "white" {}
		[NoScaleOffset]_MRAMap("MRA Map", 2D) = "white" {}
		[NoScaleOffset][Normal]_NormalMap("Normal Map", 2D) = "bump" {}
		_Color("Color", Color) = (1,1,1,1)
		_AOColor("AO Color", Color) = (1,1,1,1)
		_Rough("Roughness", Range( 0 , 2)) = 1
		_BumpScale("Normal Intensity", Range( 0 , 2)) = 1
		_CutOutIntensity("CutOut Intensity", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IgnoreProjector" = "True" }
		Cull Off
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform float _CutOutIntensity;
		uniform sampler2D _NormalMap;
		uniform sampler2D _AlbedoMap;
		uniform float4 _AlbedoMap_ST;
		uniform float _BumpScale;
		uniform float4 _AOColor;
		uniform float4 _Color;
		uniform sampler2D _MRAMap;
		uniform float _Rough;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			float dotResult39 = dot( ase_worldViewDir , ase_worldNormal );
			float3 ase_vertexNormal = v.normal.xyz;
			float3 normalizeResult41 = normalize( ase_vertexNormal );
			float3 normalizeResult40 = normalize( -ase_vertexNormal );
			float3 ifLocalVar42 = 0;
			if( dotResult39 >= 0.0 )
				ifLocalVar42 = normalizeResult41;
			else
				ifLocalVar42 = normalizeResult40;
			v.normal = ifLocalVar42;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_AlbedoMap = i.uv_texcoord * _AlbedoMap_ST.xy + _AlbedoMap_ST.zw;
			o.Normal = UnpackScaleNormal( tex2D( _NormalMap, uv_AlbedoMap ), _BumpScale );
			float4 tex2DNode1 = tex2D( _AlbedoMap, uv_AlbedoMap );
			float4 blendOpSrc32 = _AOColor;
			float4 blendOpDest32 = ( _Color * tex2DNode1 );
			float4 tex2DNode2 = tex2D( _MRAMap, uv_AlbedoMap );
			float4 lerpBlendMode32 = lerp(blendOpDest32,( blendOpSrc32 * blendOpDest32 ),( 1.0 - tex2DNode2.b ));
			o.Albedo = ( saturate( lerpBlendMode32 )).rgb;
			o.Metallic = tex2DNode2.r;
			o.Smoothness = ( 1.0 - ( _Rough * tex2DNode2.g ) );
			o.Occlusion = tex2DNode2.b;
			o.Alpha = 1;
			clip( tex2DNode1.a - _CutOutIntensity );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
141;235;1750;679;1790.853;260.5008;1.828913;True;True
Node;AmplifyShaderEditor.TexturePropertyNode;12;-1913.661,-773.6334;Float;True;Property;_AlbedoMap;Albedo Map;0;0;Create;True;0;0;0;False;0;False;None;6d0c00f241f9f2848b67760842c378e8;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.NormalVertexDataNode;34;-925.7625,1013.517;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-1901.897,27.55119;Inherit;False;0;12;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;13;-1933.586,-565.4676;Float;True;Property;_MRAMap;MRA Map;1;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;817544e267d08d7418ae2d0f2a803887;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;35;-909.1261,700.0293;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;17;-883.744,-104.5518;Float;False;Property;_Rough;Roughness;5;0;Create;False;0;0;0;False;0;False;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;37;-922.3882,860.667;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NegateNode;36;-637.1346,1105.724;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;15;-1151.061,-629.4836;Float;False;Property;_Color;Color;3;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-1343.518,-21.04497;Inherit;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-1361.725,-230.8971;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;14;-1920.069,-338.3775;Float;True;Property;_NormalMap;Normal Map;2;2;[NoScaleOffset];[Normal];Create;True;0;0;0;False;0;False;None;7638e3d4c0d12aa4bb437d6a93f94fa8;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;3;-1364.427,195.9738;Inherit;True;Property;_TextureSample2;Texture Sample 2;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;28;-822.0989,-225.5756;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;16;-886.6594,-408.1638;Float;False;Property;_AOColor;AO Color;4;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalizeNode;40;-478.6084,1104.878;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-1295.75,468.4023;Float;False;Property;_BumpScale;Normal Intensity;6;0;Create;False;0;0;0;False;0;False;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;39;-456.2956,812.448;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-525.9089,5.667345;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-891.4689,-547.3818;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-472.2956,916.662;Inherit;False;Constant;_Float1;Float 0;9;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;41;-478.6084,1008.878;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendOpsNode;32;-489.5333,-527.3685;Inherit;False;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;29;386.7806,157.7145;Float;False;Property;_CutOutIntensity;CutOut Intensity;7;0;Create;True;0;0;0;True;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;42;-207.9372,894.349;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;33;-213.8466,25.75496;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.UnpackScaleNormalNode;22;-810.1135,352.5009;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;429.7811,285.509;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;OTHYMF/MRA_Cutout;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;1;True;True;0;False;TransparentCutout;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;True;29;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;36;0;34;0
WireConnection;2;0;13;0
WireConnection;2;1;6;0
WireConnection;1;0;12;0
WireConnection;1;1;6;0
WireConnection;3;0;14;0
WireConnection;3;1;6;0
WireConnection;28;0;2;3
WireConnection;40;0;36;0
WireConnection;39;0;35;0
WireConnection;39;1;37;0
WireConnection;27;0;17;0
WireConnection;27;1;2;2
WireConnection;19;0;15;0
WireConnection;19;1;1;0
WireConnection;41;0;34;0
WireConnection;32;0;16;0
WireConnection;32;1;19;0
WireConnection;32;2;28;0
WireConnection;42;0;39;0
WireConnection;42;1;38;0
WireConnection;42;2;41;0
WireConnection;42;3;41;0
WireConnection;42;4;40;0
WireConnection;33;0;27;0
WireConnection;22;0;3;0
WireConnection;22;1;18;0
WireConnection;0;0;32;0
WireConnection;0;1;22;0
WireConnection;0;3;2;1
WireConnection;0;4;33;0
WireConnection;0;5;2;3
WireConnection;0;10;1;4
WireConnection;0;12;42;0
ASEEND*/
//CHKSM=340EA58BF86FA1A860D11B6E37051E902F82114A