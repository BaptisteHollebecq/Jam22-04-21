// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "WaterJet"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.88
		_Speed1("Speed 1", Vector) = (0,0,0,0)
		_Vector0("Vector 0", Vector) = (0,0,0,0)
		[HDR]_MainColor("Main Color", Color) = (0,0,0,0)
		_Texture0("Texture 0", 2D) = "white" {}
		_Contrast("Contrast", Range( 0 , 1)) = 0.66
		[HDR]_SecondaryColor("Secondary Color", Color) = (1,1,1,0)
		_Position("Position", Range( 0 , 1)) = 0.74
		_VertexOffset("Vertex Offset", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Background+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _VertexOffset;
		uniform sampler2D _Texture0;
		uniform float2 _Speed1;
		uniform float4 _Texture0_ST;
		uniform float2 _Vector0;
		uniform float4 _MainColor;
		uniform float4 _SecondaryColor;
		uniform float _Position;
		uniform float _Contrast;
		uniform float _Cutoff = 0.88;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 uv_Texture0 = v.texcoord.xy * _Texture0_ST.xy + _Texture0_ST.zw;
			float2 panner2 = ( _Time.y * _Speed1 + uv_Texture0);
			float2 panner30 = ( _Time.y * _Vector0 + uv_Texture0);
			float temp_output_34_0 = ( tex2Dlod( _Texture0, float4( panner2, 0, 0.0) ).r * tex2Dlod( _Texture0, float4( panner30, 0, 0.0) ).r );
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( _VertexOffset * ( temp_output_34_0 * ase_vertexNormal ) );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Texture0 = i.uv_texcoord * _Texture0_ST.xy + _Texture0_ST.zw;
			float2 panner2 = ( _Time.y * _Speed1 + uv_Texture0);
			float2 panner30 = ( _Time.y * _Vector0 + uv_Texture0);
			float temp_output_34_0 = ( tex2D( _Texture0, panner2 ).r * tex2D( _Texture0, panner30 ).r );
			float smoothstepResult23 = smoothstep( _Position , ( _Position + _Contrast ) , temp_output_34_0);
			float4 lerpResult17 = lerp( _MainColor , _SecondaryColor , smoothstepResult23);
			o.Emission = lerpResult17.rgb;
			o.Alpha = 1;
			float2 uv_TexCoord56 = i.uv_texcoord * float2( -1,-1 );
			float2 uv_TexCoord54 = i.uv_texcoord * float2( 1,4.55 ) + float2( 0,-3.59 );
			clip( ( ( temp_output_34_0 + uv_TexCoord56 ).y + ( 1.0 - uv_TexCoord54.y ) ) - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
-1582;-1847;1160;695;700.9081;22.41707;1.455088;True;False
Node;AmplifyShaderEditor.Vector2Node;5;-2401.833,-500.9985;Inherit;False;Property;_Speed1;Speed 1;1;0;Create;True;0;0;0;False;0;False;0,0;3.84,-3.18;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-2427.126,-704.7447;Inherit;False;0;10;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;28;-2405.321,206.3235;Inherit;False;Property;_Vector0;Vector 0;2;0;Create;True;0;0;0;False;0;False;0,0;0,-2.27;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;32;-2430.614,2.577343;Inherit;False;0;10;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;29;-2432.02,438.1728;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;4;-2428.532,-269.1497;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;30;-2202.979,176.8155;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;2;-2199.492,-530.5065;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;10;-2239.984,-972.636;Inherit;True;Property;_Texture0;Texture 0;4;0;Create;True;0;0;0;False;0;False;None;cf54f657bf50ffa458eb4a6620449dc8;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;1;-1929.953,-663.0447;Inherit;True;Property;_Albedo;Albedo;1;0;Create;True;0;0;0;False;0;False;-1;None;cf54f657bf50ffa458eb4a6620449dc8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;33;-1933.441,44.27737;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;cf54f657bf50ffa458eb4a6620449dc8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-1397.756,-300.7472;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-1038.052,171.9418;Inherit;False;Property;_Contrast;Contrast;5;0;Create;True;0;0;0;False;0;False;0.66;0.117;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-1011.333,29.67007;Inherit;False;Property;_Position;Position;7;0;Create;True;0;0;0;False;0;False;0.74;0.377;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;56;-790.155,861.4594;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;-1,-1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;57;-530.0135,794.2457;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;-720.2764,108.9963;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;38;-746.2744,486.7697;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;54;-143.0702,530.1813;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,4.55;False;1;FLOAT2;0,-3.59;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;7;-676.5751,-483.836;Inherit;False;Property;_MainColor;Main Color;3;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0.4117647,0.8235294,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;18;-697.1921,-296.1747;Inherit;False;Property;_SecondaryColor;Secondary Color;6;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;2,2,2,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-488.2438,370.3522;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-456.8827,232.1766;Inherit;False;Property;_VertexOffset;Vertex Offset;8;0;Create;True;0;0;0;False;0;False;0;0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;23;-594.5927,-37.63482;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;62;130.7477,586.0012;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;64;-200.3579,872.462;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-283.8827,296.1766;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;17;-350.9914,-157.1365;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;58;359.9977,621.2615;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.34;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;379.4924,9.64841;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;WaterJet;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.88;True;True;0;True;Opaque;;Background;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;30;0;32;0
WireConnection;30;2;28;0
WireConnection;30;1;29;2
WireConnection;2;0;3;0
WireConnection;2;2;5;0
WireConnection;2;1;4;2
WireConnection;1;0;10;0
WireConnection;1;1;2;0
WireConnection;33;0;10;0
WireConnection;33;1;30;0
WireConnection;34;0;1;1
WireConnection;34;1;33;1
WireConnection;57;0;34;0
WireConnection;57;1;56;0
WireConnection;26;0;24;0
WireConnection;26;1;27;0
WireConnection;39;0;34;0
WireConnection;39;1;38;0
WireConnection;23;0;34;0
WireConnection;23;1;24;0
WireConnection;23;2;26;0
WireConnection;62;0;54;2
WireConnection;64;0;57;0
WireConnection;40;0;41;0
WireConnection;40;1;39;0
WireConnection;17;0;7;0
WireConnection;17;1;18;0
WireConnection;17;2;23;0
WireConnection;58;0;64;1
WireConnection;58;1;62;0
WireConnection;0;2;17;0
WireConnection;0;10;58;0
WireConnection;0;11;40;0
ASEEND*/
//CHKSM=0E4F7E04C6E1549C23B7D60371B9018B2C629429